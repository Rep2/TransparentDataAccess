import RxSwift
//
//class TracksInFlightGetGateway<R, T where T:TargetType, T:StorableType>: GetGateway<R, T> {
//
//    let gateway: GetGateway<R, T>
//
//    var numberOfGetRequests: Int = 0
//
//    init(gateway: GetGateway<R, T>) {
//        self.gateway = gateway
//    }
//
//    override func getResource(resourceType: T, forceRefresh: Bool) -> Observable<R> {
//        numberOfGetRequests += 1
//
//       return gateway.getResource(resourceType, forceRefresh: forceRefresh)
//    }
//
//}
