//
//  KeychainGatewayTest.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import RxSwift
@testable import TransparentDataAccess

class KeychainGatewayTest: XCTestCase {
    
    func test_SimpleModel_NoData(){
        let target = ResourceTargetExample<SimpleModel>.EmptyTarget
        var recievedError: GatewayError?
        
        _ = KeychainGateway().getResource(target).subscribeError { (error) in
            if let error = error as? GatewayError{
                recievedError = error
            }
        }
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_SimpleModel_SetResource(){
        let testModel = SimpleModel(data: "New test data")
        let gateway = KeychainGateway<SimpleModel>()
        var recievedModel: SimpleModel?
        
        gateway.setResource(.EmptyTarget, resource: testModel)
        
        _ = gateway.getResource(.EmptyTarget).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.data).to(equal(testModel.data))
    }
    
    func test_Token_GetResource(){
        let testModel = TwitterAccessToken(data: "test token")
        let target = ResourceTargetExample<TwitterAccessToken>.Token(key: "key", secret: "secret")
        
        var recievedModel: TwitterAccessToken?
        
        keychain[target.key] = testModel.toString()
        
        _ = KeychainGateway().getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }
    
    func test_Token_NoData(){
        var recievedError: GatewayError?
        let target = ResourceTargetExample<TwitterAccessToken>.Token(key: "different key", secret: "secret")
        
        _ = KeychainGateway<TwitterAccessToken>().getResource(target).subscribeError { (error) in
            if let error = error as? GatewayError{
                recievedError = error
            }
        }
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_Token_SetResource(){
        let testModel = TwitterAccessToken(data: "new token")
        let target = ResourceTargetExample<TwitterAccessToken>.Token(key: "key", secret: "different secret")
        let gateway = KeychainGateway<TwitterAccessToken>()
        var recievedModel: TwitterAccessToken?
        
        gateway.setResource(target, resource: testModel)
        
        _ = gateway.getResource(target).subscribeNext { (model) in
            recievedModel = model
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }
    
}