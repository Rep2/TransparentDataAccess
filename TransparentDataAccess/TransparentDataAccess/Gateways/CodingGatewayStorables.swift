import RxSwift

class CodingGateway<R: NSCoding, T: StorableType>: GetSetGateway<R, T> {

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.create({ (observer) -> Disposable in
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(resourceType.key) as? NSData {
                if let resource = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? R {
                    observer.onNext(resource)
                    observer.onCompleted()
                } else {
                    observer.onError(GatewayError.CodingFailed)
                }
            } else {
                observer.onError(GatewayError.NoDataFor(key: resourceType.key))
            }

            return NopDisposable.instance
        })
        .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)))
    }

    override func setResource(resourceType: T, resource: R) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(resource)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: resourceType.key)
    }
}
