import RxSwift
import Simple_KeychainSwift
import Unbox

/// Set to wanted walue
let keychainServiceString = "undabot.TransparentDataAccess"

/// Resource that can be stored and fetched using keychain gateway
protocol Keychainable {
    init(data: String)

    func toString() -> String
}

class KeychainGateway {

    func getResource<Resource: Keychainable, Target: StorableTarget>(resourceTarget: Target, forceRefresh: Bool = false) -> Observable<Resource> {
        let resourceKey = keychainServiceString + resourceTarget.key

        let resourceValue = Keychain.value(forKey: resourceKey)

        if resourceValue != nil && !forceRefresh {
            return Observable.just(Resource(data: resourceValue!))
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceTarget.key))
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        }
    }

    func setResource<Resource: Keychainable, Target: StorableTarget>(resourceTarget: Target, resource: Resource) {
        Keychain.set(resource.toString(), forKey: keychainServiceString + resourceTarget.key)
    }
}

struct CompositeGateway<Resource where Resource: Unboxable, Resource: Keychainable> {

    var localGateway: LocalGateway<Resource>
    let keychainGateway: KeychainGateway
    let webGateway: WebGateway

    init(localGateway: LocalGateway<Resource>, keychainGateway: KeychainGateway, webGateway: WebGateway) {
        self.localGateway = localGateway
        self.keychainGateway = keychainGateway
        self.webGateway = webGateway
    }

    mutating func getResource<Target: ResourceTarget>(resourceTarget: Target, forceRefresh: Bool = false) -> Observable<Resource> {
        if !forceRefresh {
            return Observable
            .of(
                localGateway.getResource(resourceTarget)
                    .catchError { error in
                        return .empty()
                },
                keychainGateway.getResource(resourceTarget)
                    .catchError { error in
                        return .empty()
                },
                webGateway.getResource(resourceTarget)
                    .doOnNext {
                        self.localGateway.setResource(resourceTarget, resource: $0)
                        self.keychainGateway.setResource(resourceTarget, resource: $0)
                }
            )
            .merge()
            .take(1)
        } else {
            return webGateway.getResource(resourceTarget)
                .doOnNext {
                    self.localGateway.setResource(resourceTarget, resource: $0)
                    self.keychainGateway.setResource(resourceTarget, resource: $0)
            }
        }
    }
}
