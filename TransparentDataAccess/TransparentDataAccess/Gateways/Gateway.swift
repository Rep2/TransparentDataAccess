import RxSwift
import Moya

/// Target that can be stored using default gateways
protocol StorableType {
    var key: String { get }
}

/// Get gateway interface
class GetGateway<R, T> {
    func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.empty()
    }
}

/// GetSet gateway interface
class GetSetGateway<R, T: StorableType>: GetGateway<R, T> {
    func setResource(resourceType: T, resource: R) {
    }
}
