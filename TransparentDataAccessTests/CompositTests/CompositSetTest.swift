////
////  CompositSetTest.swift
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
//class CompositSetTest: XCTestCase{
//    
//    func test_LocalComposite_SetFirst(){
//        let type = ResourceTypeExample.Token(key: "key", secret: "secret")
//        let token = TwitterAccessToken(data: "token")
//        
//        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
//        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [type.key : token])
//        
//        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
//        
//        var recievedToken: TwitterAccessToken?
//        
//        waitUntil(action: { done in
//            _ = compositGateway.getResource(type)
//                .subscribe(
//                    onDisposed: {
//                        done()
//                })
//        })
//        
//        waitUntil(action: { done in
//            _ = firstGateway.getResource(type)
//                .subscribeNext({ (token) in
//                    recievedToken = token
//                    done()
//                })
//        })
//        
//        expect(recievedToken).toNot(beNil())
//    }
//    
//    func test_LocalComposite_SetFirstAndSecond(){
//        let type = ResourceTypeExample.Token(key: "key", secret: "secret")
//        let token = TwitterAccessToken(data: "token")
//        
//        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
//        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
//        let thirdGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [type.key : token])
//        
//        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway, thirdGateway])
//        
//        var firstRecievedToken: TwitterAccessToken?
//        var secondRecievedToken: TwitterAccessToken?
//        
//        waitUntil(action: { done in
//            _ = compositGateway.getResource(type)
//                .subscribe(
//                    onDisposed: {
//                        done()
//                })
//        })
//        
//        waitUntil(action: { done in
//            _ = firstGateway.getResource(type)
//                .subscribeNext({ (token) in
//                    firstRecievedToken = token
//                    done()
//                })
//        })
//        
//        waitUntil(action: { done in
//            _ = firstGateway.getResource(type)
//                .subscribeNext({ (token) in
//                    secondRecievedToken = token
//                    done()
//                })
//        })
//        
//        expect(firstRecievedToken).toNot(beNil())
//        expect(secondRecievedToken).toNot(beNil())
//    }
//}