import RxSwift
import Moya
import Unbox

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
                        if let tokenRefreshAction = self.tokenRefreshAction, error = error as? GatewayError {
                            if error == GatewayError.HTTPError(code: 401) {
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
        return
            // Allows subclass preform updates
            gateway.createProvider()
                .flatMap({ (newProvider) -> Observable<R> in

                    // Mapps Moya response to object with token refresh disabled
                    return gateway.mapper.mapResponse(newProvider.request(resourceType), refreshesToken: false)
                })
    }
}
