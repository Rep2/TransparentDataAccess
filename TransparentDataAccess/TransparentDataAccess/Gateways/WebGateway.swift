import RxSwift
import Unbox
import Alamofire
import RxAlamofire

struct WebGateway {
    func getResource<Resource: Unboxable, Target: WebTarget>(resourceTarget: Target) -> Observable<Resource> {
        let queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

        return
            Manager.sharedInstance
                .rx_request(resourceTarget.URLRequest)
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: queue))
                .flatMap ({ request -> Observable<Resource> in

                    return request.unbox(queue)
        })
    }
}

struct WebGatewayWithRefresh {

    let refreshAction: Observable<TwitterAccessToken>

    let disposeBag = DisposeBag()

    init(refreshAction: Observable<TwitterAccessToken>) {
        self.refreshAction = refreshAction
    }

    func getResource<Resource: Unboxable, Target: RefreshableTarget>(resourceTarget: Target, refreshToken: Bool = true) -> Observable<Resource> {
        let queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

        return
            Manager.sharedInstance
                .rx_request(resourceTarget.URLRequest)
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: queue))
                .flatMap ({ request -> Observable<Resource> in

                    return request.unbox(queue)
                })
                .catchError({ (error) -> Observable<Resource> in
                    if refreshToken {
                        return self.refreshAction
                            .flatMap { refreshResource -> Observable<Resource> in
                                return .empty()// TODO refersh token
                        }
                    }

                    return .error(error)
                })
    }
}



struct WebGatewayWithCaching<Resource: Unboxable> {

    var localGateway: LocalGateway<Resource>
    let webGateway: WebGateway

    init(localGateway: LocalGateway<Resource>, webGateway: WebGateway) {
        self.localGateway = localGateway
        self.webGateway = webGateway
    }

    mutating func getResource<Target: ResourceTarget>(resourceTarget: Target) -> Observable<Resource> {
        return Observable
            .of(
                localGateway.getResource(resourceTarget)
                    .catchError { error in
                        return .empty()
                },
                webGateway.getResource(resourceTarget)
                    .doOnNext { self.localGateway.setResource(resourceTarget, resource: $0) }
            )
            .merge()
            .take(1)
    }
}

extension Request {

    func unbox<R: Unboxable>(queue: dispatch_queue_t? = nil) -> Observable<R> {

        return rx_result(queue: queue, responseSerializer: Request.dataResponseSerializer())
            .flatMap({ (data) -> Observable<R> in

                return Observable.create({ (observer) -> Disposable in
                    do {
                        let resource: R = try Unbox(data)

                        observer.onNext(resource)
                        observer.onCompleted()
                    } catch {
                        observer.onError(GatewayError.UnboxingError)
                    }

                    return NopDisposable.instance
                })
            })
    }

}
