import RxSwift

enum CodingGatewayError: ErrorType {
    case NoDataForKey(key: String)
    case CodingFailed
}

extension CodingGatewayError: Equatable {
}

func == (lhs: CodingGatewayError, rhs: CodingGatewayError) -> Bool {
    switch (lhs, rhs) {
    case (.NoDataForKey(let x), .NoDataForKey(let y)):
        return x == y
    case (.CodingFailed, .CodingFailed):
        return true
    default:
        return false
    }
}

class CodingGateway<R: NSCoding, T: StorableType>: GetSetGateway<R, T> {

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.create({ (observer) -> Disposable in
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(resourceType.key) as? NSData {
                if let resource = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? R {
                    observer.onNext(resource)
                    observer.onCompleted()
                } else {
                    observer.onError(CodingGatewayError.CodingFailed)
                }
            } else {
                observer.onError(CodingGatewayError.NoDataForKey(key: resourceType.key))
            }

            return NopDisposable.instance
        })
    }

    override func setResource(resourceType: T, resource: R) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(resource)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: resourceType.key)
    }
}
