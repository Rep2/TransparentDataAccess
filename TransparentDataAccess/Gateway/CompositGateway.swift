//
//  CompositGateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

class CompositGateway<R, T: ResourceType>: GetGateway<R, T>{
    
    var gateways: [GetGateway<R, T>] = []
    
    init(gateways: [GetGateway<R, T>] = []){
        self.gateways = gateways
    }
    
    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return gateways.map { (gateway) -> Observable<R> in
            return Observable.deferred({
                return gateway.getResource(resourceType).catchError({ (error) -> Observable<R> in
                    return Observable.empty()
                }).observeOn(MainScheduler.instance)
            })
            }
            .concat()
            .observeOn(MainScheduler.instance)
            .take(1)
    }
    
}