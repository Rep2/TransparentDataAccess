import RxSwift

struct CodingGateway {

    func getResource<Resource, Target: StorableTarget>(resourceTarget: Target, forceRefresh: Bool = false) -> Observable<Resource> {

        return Observable.create({ (observer) -> Disposable in
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(resourceTarget.key) as? NSData {
                if let resource = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Resource {
                    observer.onNext(resource)
                    observer.onCompleted()
                } else {
                    observer.onError(GatewayError.CodingFailed)
                }
            } else {
                observer.onError(GatewayError.NoDataFor(key: resourceTarget.key))
            }

            return NopDisposable.instance
        })
        .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
    }

    func setResource<R: NSCoding, T: StorableTarget>(resourceType: T, resource: R) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(resource)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: resourceType.key)
    }
}


struct CodingGatewayWithCaching<Resource: NSCoding> {

    var localGateway: LocalGateway<Resource>
    let codingGateway: CodingGateway

    init(localGateway: LocalGateway<Resource>, codingGateway: CodingGateway) {
        self.localGateway = localGateway
        self.codingGateway = codingGateway
    }

    mutating func getResource<Target: StorableTarget>(resourceTarget: Target) -> Observable<Resource> {
        return Observable
            .of(
                localGateway.getResource(resourceTarget)
                    .catchError { error in
                        return .empty()
                },
                codingGateway.getResource(resourceTarget)
                    .doOnNext { self.localGateway.setResource(resourceTarget, resource: $0) }
            )
            .merge()
            .take(1)
    }

    func setResource<Target: StorableTarget>(resourceType: Target, resource: Resource) {
        codingGateway.setResource(resourceType, resource: resource)
    }
}
