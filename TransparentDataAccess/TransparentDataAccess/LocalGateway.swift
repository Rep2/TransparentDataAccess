import RxSwift

class LocalGateway<R, T: StorableType>: GetSetGateway<R, T> {
    var resources: [String : R]

    init(resources: [String : R] = [:]) {
        self.resources = resources
    }

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        let resource = resources[resourceType.key]

        if  resource != nil && !forceRefresh {
            return Observable.just(resource!)
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceType.key))
                .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
        }
    }

    override func setResource(resourceType: T, resource: R) {
        resources[resourceType.key] = resource
    }
}
