//
//  CompositGatewayTest.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Nimble
@testable import TransparentDataAccess

class CompositGatewayResultTest: XCTestCase{
    
    func test_TwoLocalGatewaysComposite_NoData(){
        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedToken: TwitterAccessToken?
        
        _ = compositGateway.getResource(ResourceTypeExample.Token(key: "test key", secret: "test secret"))
            .subscribeNext { (token) in
                recievedToken = token
        }
        
        expect(recievedToken).to(beNil())
    }
    
    func test_TwoLocalGatewaysComposite_NoDataCompleted(){
        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var completed = false
        var recievedError: ErrorType?
        
        waitUntil { (done) in
            _ = compositGateway.getResource(ResourceTypeExample.Token(key: "test key", secret: "test secret"))
                .subscribe(
                    onError: { (error) in
                        recievedError = error
                    }, onCompleted: {
                        completed = true
                        done()
                })
        }
        
        expect(recievedError).to(beNil())
        expect(completed).to(equal(true))
    }
    
    func test_TwoLocalGatewaysComposite_DataInFirst(){
        let token = TwitterAccessToken(data: "test token")
        let type = ResourceTypeExample.Token(key: "test key2", secret: "test secret2")
        
        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [type.key :  token])
        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedToken: TwitterAccessToken?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(type)
                .subscribeNext { (token) in
                    recievedToken = token
                    done()
            }
        })
        
        expect(recievedToken).toNot(beNil())
    }
    
    func test_TwoLocalGatewaysComposite_DataInSecond(){
        let token = TwitterAccessToken(data: "test token")
        let type = ResourceTypeExample.Token(key: "test key2", secret: "test secret2")
        
        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let secondGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [type.key :  token])
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedToken: TwitterAccessToken?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(type)
                .subscribeNext { (token) in
                    recievedToken = token
                    done()
            }
        })
        
        expect(recievedToken).toNot(beNil())
    }
}