import KeychainAccess
import RxSwift

/// Set to wanted walue
let keychainServiceString = "undabot.TransparentDataAccess"

/// Resource that can be stored and fetched using keychain gateway
protocol Keychainable {
    init(data: String)

    func toString() -> String
}

let keychain = Keychain(service: keychainServiceString)

class KeychainGateway<R: Keychainable, T: StorableType>: GetSetGateway<R, T> {

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
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
