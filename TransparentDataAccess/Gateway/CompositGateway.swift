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
        return gateways.enumerate().map { (index, gateway) -> Observable<R> in
            return Observable.deferred({
                return gateway.getResource(resourceType)
                    .doOnNext({ resource in
                        for i in 0..<index{
                            if self.gateways[i] is GetSetGateway{
                                (self.gateways[i] as! GetSetGateway).setResource(resourceType, resource: resource)
                            }
                        }
                    })
                    .catchError({ (error) -> Observable<R> in
                        if index == (self.gateways.count - 1){
                            return Observable.error(error)
                        }else{
                            return Observable.empty()
                        }
                }).observeOn(MainScheduler.instance)
            })
            }
            .concat()
            .observeOn(MainScheduler.instance)
            .take(1)
    }
    
}