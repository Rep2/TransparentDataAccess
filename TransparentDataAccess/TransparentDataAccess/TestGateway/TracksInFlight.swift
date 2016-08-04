//
//  TracksInFlight.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 03/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

class TracksInFlightGetGateway<R, T: ResourceType>: GetGateway<R, T>{
    
    let gateway: GetGateway<R, T>
    
    var numberOfGetRequests: Int = 0
    
    init(gateway: GetGateway<R, T>){
        self.gateway = gateway
    }
    
    override func getResource(resourceType: T, forceRefresh: Bool) -> Observable<R> {
        numberOfGetRequests += 1
        
       return gateway.getResource(resourceType, forceRefresh: forceRefresh)
    }
    
}