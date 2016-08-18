import RxSwift
import Moya
import Unbox

enum WebRequestError: ErrorType {
    case HTTPError(code: Int)
    case UnboxingError
    case SystemError(code: Int, description: String)
    case PermissionDenied
    case NoDataReturned

    var description: String {
        switch self {
        case .HTTPError(let code):
            return "HTTP error with status code \(code)"
        case .UnboxingError:
            return "Error while mapping response body"
        case .SystemError(_, let description):
            return description
        case .PermissionDenied:
            return "Permission was denied"
        case .NoDataReturned:
            return "Request returned no data"
        }
    }
}

extension WebRequestError: Equatable {
}

func == (lhs: WebRequestError, rhs: WebRequestError) -> Bool {
    switch (lhs, rhs) {
    case (.HTTPError(let x), .HTTPError(let y)):
        return x == y
    case (.UnboxingError, .UnboxingError):
        return true
    case (.PermissionDenied, .PermissionDenied):
        return true
    case (.NoDataReturned, .NoDataReturned):
        return true
    default:
        return false
    }
}

class WebGateway<R: Unboxable, T: TargetType>: GetGateway<R, T> {
    var provider: RxMoyaProvider<T>!
    let mapper: ResourceMapperProtocol

    let tokenRefreshAction: ((gateway: WebGateway<R, T>, resourceType: T) -> Observable<R>)?

    init(provider: RxMoyaProvider<T>? = RxMoyaProvider<T>(), mapper: ResourceMapperProtocol = ResourceMapper(),
         tokenRefreshAction: ((gateway: WebGateway<R, T>, resourceType: T) -> Observable<R>)? = WebGateway.standartdTokenRefreshAction) {
        self.provider = provider
        self.mapper = mapper

        self.tokenRefreshAction = tokenRefreshAction
    }

    override final func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return createProvider()
            .flatMap({ (provider) -> Observable<R> in
                // Mapps Moya response to object with token refresh enabled
                return self.mapper.mapResponse(provider.request(resourceType), refreshesToken: true)

                    // Catch 401 errors and automaticaly tries to refresh token
                    .catchError({ (error) -> Observable<R> in
                        if let tokenRefreshAction = self.tokenRefreshAction, error = error as? WebRequestError {
                            if error == WebRequestError.HTTPError(code: 401) {
                                return tokenRefreshAction(gateway: self, resourceType: resourceType)
                            }
                        }

                        return Observable.error(error)
                    })
            })
    }

    func createProvider() -> Observable<RxMoyaProvider<T>> {
        return Observable.just(provider)
    }

    static func standartdTokenRefreshAction(gateway: WebGateway<R, T>, resourceType: T) -> Observable<R> {
        return Observable.empty()
    }
}
