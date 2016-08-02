//
//  TransparentDataAccessTests.swift
//  TransparentDataAccessTests
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import XCTest
import RxSwift
import Unbox
import Nimble
@testable import TransparentDataAccess

class LocalGatewayTest: XCTestCase {
    
    func test_SimpleModel_GetResource(){
        let testModel = SimpleModel(data: "Test data")
        let target = ResourceTypeExample.EmptyTarget
        var recievedModel: SimpleModel?
        
        _ = LocalGateway(resources: [target.key : testModel]).getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.data).to(equal(testModel.data))
    }
    
    func test_SimpleModel_NoData(){
        let target = ResourceTypeExample.EmptyTarget
        var recievedError: GatewayError?
        
        _ = LocalGateway<SimpleModel, ResourceTypeExample>().getResource(target).subscribeError { (error) in
            if let error = error as? GatewayError{
                recievedError = error
            }
        }
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_SimpleModel_SetResource(){
        let testModel = SimpleModel(data: "New test data")
        let target = ResourceTypeExample.EmptyTarget
        let gateway = LocalGateway<SimpleModel, ResourceTypeExample>(resources: [target.key : SimpleModel(data: "Old test data")])
        var recievedModel: SimpleModel?
        
        gateway.setResource(target, resource: testModel)
        
        _ = gateway.getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.data).to(equal(testModel.data))
    }
    
    func test_Token_GetResource(){
        let testModel = TwitterAccessToken(data: "test token")
        let target = ResourceTypeExample.Token(key: "key", secret: "secret")
        var recievedModel: TwitterAccessToken?
        
        _ = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [target.key : testModel]).getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }
    
    func test_Token_NoData(){
        var recievedError: GatewayError?
        let target = ResourceTypeExample.Token(key: "key", secret: "secret")
        
        _ = LocalGateway<TwitterAccessToken, ResourceTypeExample>().getResource(target).subscribeError { (error) in
            if let error = error as? GatewayError{
                recievedError = error
            }
        }
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_Token_SetResource(){
        let testModel = TwitterAccessToken(data: "new token")
        let target = ResourceTypeExample.Token(key: "key", secret: "secret")
        let gateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>(resources: [target.key : TwitterAccessToken(data: "old token")])
        var recievedModel: TwitterAccessToken?
        
        gateway.setResource(target, resource: testModel)
        
        _ = gateway.getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }
}
