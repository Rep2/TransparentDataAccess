import KeychainAccess
import RxSwift

protocol Keychainable {
    init(data: String)

    func toString() -> String
}

let keychainServiceString = "undabot.TransparentDataAccess"
let keychain = Keychain(service: keychainServiceString)

class KeychainGateway<R: Keychainable, T: StorableType>: GetSetGateway<R, T> {
    private let keychainKey = "TwitterAccessToken"

    override func getResource(resourceType: T,
                              forceRefresh: Bool = false) -> Observable<R> {
        let resourceString = keychain[resourceType.key]

        if resourceString != nil && !forceRefresh {
            return Observable.just(R(data: resourceString!))
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceType.key))
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        }
    }

    override func setResource(resourceType: T, resource: R) {
        keychain[resourceType.key] = resource.toString()
    }
}
