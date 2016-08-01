//
//  LocalGateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

class LocalGateway<R>: GetGateway<R>{
    var resources: [String : R]
    
    init(resources: [String : R] = [:]){
        self.resources = resources
    }
    
    override func getResource(resourceType: ResourceTargetExample<R>, forceRefresh: Bool = false) -> Observable<R>{
        let resource = resources[resourceType.key]
        
        if  resource != nil && !forceRefresh{
            return Observable.just(resource!)
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceType.key))
        }
    }
    
    func setResource(resourceType: ResourceTargetExample<R>, resource: R){
        resources[resourceType.key] = resource
    }
}