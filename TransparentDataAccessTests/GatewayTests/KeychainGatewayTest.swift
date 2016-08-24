////
////  KeychainGatewayTest.swift
////  TransparentDataAccess
////
////  Created by Undabot Rep on 01/08/16.
////  Copyright © 2016 Undabot. All rights reserved.
////
//
//import Foundation
//import XCTest
//import Nimble
//import RxSwift
//@testable import TransparentDataAccess
//
//class KeychainGatewayTest: XCTestCase {
//
//    func test_SimpleModel_NoData(){
//        let target = ResourceTypeExample.Token(key: "no data", secret: "secret")
//        var recievedError: GatewayError?
//
//        waitUntil { (done) in
//            _ = KeychainGateway<SimpleModel, ResourceTypeExample>().getResource(target).subscribeError { (error) in
//                if let error = error as? GatewayError{
//                    recievedError = error
//                    done()
//                }
//            }
//        }
//
//        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
//    }
//
//    func test_SimpleModel_SetResource(){
//        let testModel = SimpleModel(data: "New test data")
//        let gateway = KeychainGateway<SimpleModel, ResourceTypeExample>()
//        var recievedModel: SimpleModel?
//
//        gateway.setResource(ResourceTypeExample.EmptyTarget, resource: testModel)
//
//        waitUntil { (done) in
//            _ = gateway.getResource(ResourceTypeExample.EmptyTarget).subscribeNext { (model) in
//                recievedModel = model
//                done()
//            }
//        }
//
//        expect(recievedModel).toNot(beNil())
//        expect(recievedModel!.data).to(equal(testModel.data))
//    }
//
//    func test_Token_GetResource(){
//        let testModel = TwitterAccessToken(data: "test token")
//        let target = ResourceTypeExample.Token(key: "key", secret: "secret")
//
//        var recievedModel: TwitterAccessToken?
//
//        keychain[target.key] = testModel.toString()
//
//        waitUntil { (done) in
//            _ = KeychainGateway<TwitterAccessToken, ResourceTypeExample>().getResource(target).subscribeNext { (model) in
//                recievedModel = model
//                done()
//            }
//        }
//
//        expect(recievedModel).toNot(beNil())
//        expect(recievedModel!.token).to(equal(testModel.token))
//    }
//
//    func test_Token_NoData(){
//        var recievedError: GatewayError?
//        let target = ResourceTypeExample.Token(key: "different key", secret: "secret")
//
//        waitUntil { (done) in
//            _ = KeychainGateway<TwitterAccessToken, ResourceTypeExample>().getResource(target).subscribeError { (error) in
//                if let error = error as? GatewayError{
//                    recievedError = error
//                    done()
//                }
//            }
//        }
//
//        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
//    }
//
//    func test_Token_SetResource(){
//        let testModel = TwitterAccessToken(data: "new token")
//        let target = ResourceTypeExample.Token(key: "key", secret: "different secret")
//        let gateway = KeychainGateway<TwitterAccessToken, ResourceTypeExample>()
//        var recievedModel: TwitterAccessToken?
//
//        gateway.setResource(target, resource: testModel)
//
//        waitUntil { (done) in
//            _ = gateway.getResource(target).subscribeNext { (model) in
//                recievedModel = model
//                done()
//            }
//        }
//        
//        expect(recievedModel).toNot(beNil())
//        expect(recievedModel!.token).to(equal(testModel.token))
//    }
//}