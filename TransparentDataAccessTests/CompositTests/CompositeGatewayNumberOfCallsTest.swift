////
////  CompositeGatewayNumberOfCallsTest.swift
////  TransparentDataAccess
////
////  Created by Undabot Rep on 02/08/16.
////  Copyright © 2016 Undabot. All rights reserved.
////
//
//import Foundation
//import XCTest
//import RxSwift
//import Nimble
//@testable import TransparentDataAccess
//
//class LocalGatewayWithLogger<R, T: StorableType>: LocalGateway<R, T>{
//    var numberOfGetCalls = 0
//    var numberOfSetCalls = 0
//    
//    override init(resources: [String : R] = [:]) {
//        super.init(resources: resources)
//    }
//    
//    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R>{
//        numberOfGetCalls += 1
//        
//        return super.getResource(resourceType, forceRefresh: forceRefresh)
//    }
//    
//    override func setResource(resourceType: T, resource: R){
//        numberOfSetCalls += 1
//        
//        super.setResource(resourceType, resource: resource)
//    }
//    
//    
//}
//
//class CompositeGatewayNumberOfCallsTest: XCTestCase{
//    
//    func test_TwoLocalGatewaysComposite_NoData(){
//        let firstGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>()
//        let secondGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>()
//        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
//        
//        waitUntil(action: { done in
//            _ = compositGateway.getResource(ResourceTypeExample.Token(key: "test key", secret: "test secret"))
//                .subscribe(onDisposed: {
//                    done()
//                })
//        })
//        
//        expect(firstGateway.numberOfGetCalls).to(equal(1))
//        expect(secondGateway.numberOfGetCalls).to(equal(1))
//    }
//    
//    func test_TwoLocalGatewaysComposite_DataInFirst(){
//        let token = TwitterAccessToken(data: "test token")
//        let type = ResourceTypeExample.Token(key: "test key", secret: "test secret")
//        
//        let firstGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>(resources: [type.key :  token])
//        let secondGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>(resources: [type.key :  token])
//        let thirdGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>()
//        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway, thirdGateway])
//        
//        waitUntil(action: { done in
//            _ = compositGateway.getResource(type)
//            .subscribe(onDisposed: {
//                done()
//            })
//        })
//        
//        expect(firstGateway.numberOfGetCalls).to(equal(1))
//        expect(secondGateway.numberOfGetCalls).to(equal(0))
//        expect(thirdGateway.numberOfGetCalls).to(equal(0))
//    }
//    
//    func test_TwoLocalGatewaysComposite_DataInSecond(){
//        let token = TwitterAccessToken(data: "test token")
//        let type = ResourceTypeExample.Token(key: "test key", secret: "test secret")
//        
//        let firstGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>()
//        let secondGateway = LocalGatewayWithLogger<TwitterAccessToken, ResourceTypeExample>(resources: [type.key :  token])
//        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
//        
//        waitUntil(action: { done in
//            _ = compositGateway.getResource(ResourceTypeExample.Token(key: "test key", secret: "test secret"))
//                .subscribe(onDisposed: {
//                    done()
//                })
//        })
//        
//        expect(firstGateway.numberOfGetCalls).to(equal(1))
//        expect(secondGateway.numberOfGetCalls).to(equal(1))
//    }
//    
//    
//}
