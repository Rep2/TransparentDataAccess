import RxSwift

class CompositGateway<R, T: StorableType>: GetSetGateway<R, T> {

    var gateways: [GetGateway<R, T>] = []

    init(gateways: [GetGateway<R, T>] = []) {
        self.gateways = gateways
    }

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        let scheduler = CurrentThreadScheduler.instance

        return gateways.enumerate().map { (index, gateway) -> Observable<R> in
            return Observable.deferred({
                return gateway.getResource(resourceType, forceRefresh: forceRefresh)
                    .doOnNext({ resource in
                        for i in 0..<index {
                            if self.gateways[i] is GetSetGateway {
                                if let gateway = self.gateways[i] as? GetSetGateway {
                                    gateway.setResource(resourceType, resource: resource)
                                }
                            }
                        }
                    })
                    .catchError({ (error) -> Observable<R> in
                        if index == (self.gateways.count - 1) {
                            return Observable.error(error)
                        } else {
                            return Observable.empty()
                        }
                }).observeOn(scheduler)
            })
            }
            .concat()
            .observeOn(scheduler)
            .take(1)
    }

    override func setResource(resourceType: T, resource: R) {
        for gateway in gateways {
            if let gateway = gateway as? GetSetGateway {
                gateway.setResource(resourceType, resource: resource)
            }
        }
    }

}
