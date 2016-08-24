import RxSwift

struct LocalGateway<Resource> {
    var resources: [String : Resource]

    init(resources: [String : Resource] = [:]) {
        self.resources = resources
    }

    func getResource<Target: StorableTarget>(resourceTarget: Target, forceRefresh: Bool = false) -> Observable<Resource> {
        let resource = resources[resourceTarget.key]

        if  resource != nil && !forceRefresh {
            return Observable.just(resource!)
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceTarget.key))
        }
    }

    mutating func setResource<Target: StorableTarget>(resourceTarget: Target, resource: Resource) {
        resources[resourceTarget.key] = resource
    }
}
