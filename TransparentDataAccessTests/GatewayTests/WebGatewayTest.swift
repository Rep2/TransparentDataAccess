//
//  WebGatewayTest.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import RxSwift
import Moya
@testable import TransparentDataAccess

class WebGatewayTest: XCTestCase {
    
    func test_UserProfile_SuccessfulRequest(){
        let target = GitHub.UserProfile("Rep2")
        var recievedModel: UserProfile?
        let gateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider())
        
        waitUntil(timeout: 30, action: { done in
            _ = gateway.getResource(target).subscribeNext{ (model) in
                    recievedModel = model
                    done()
                }
        })
        
        expect(recievedModel).toNot(beNil())
    }
    
    func test_UserProfile_NoUserError(){
        let target = GitHub.UserProfile("Rep2123121")
        var recievedError: WebRequestError?
        let gateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider())
        
        waitUntil(timeout: 30, action: { done in
            _ = gateway.getResource(target).subscribeError{ (error) in
                if let error = error as? WebRequestError{
                    recievedError = error
                }
                
                done()
            }
        })
        
        expect(recievedError).to(equal(WebRequestError.HTTPError(code: 404)))
    }
    
    func test_Error_HTTP400(){
        let target = GitHub.UserProfile("Rep2")
        var recievedError: WebRequestError?
        let gateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider.init(
            endpointClosure: { (target) -> Endpoint<GitHub> in
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                return Endpoint<GitHub>(URL: url, sampleResponseClosure: {.NetworkResponse(400, target.sampleData)}, method: target.method, parameters: target.parameters)
            }, stubClosure: MoyaProvider.ImmediatelyStub))
        
        waitUntil(timeout: 30, action: { done in
            _ = gateway.getResource(target).subscribeError{ (error) in
                if let error = error as? WebRequestError{
                    recievedError = error
                }
                
                done()
            }
        })
        
        expect(recievedError).to(equal(WebRequestError.HTTPError(code: 400)))
    }
    
    func test_Error_HTTP401(){
        let target = GitHub.UserProfile("Rep2")
        var recievedError: WebRequestError?
        let gateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider.init(
            endpointClosure: { (target) -> Endpoint<GitHub> in
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                return Endpoint<GitHub>(URL: url, sampleResponseClosure: {.NetworkResponse(401, target.sampleData)}, method: target.method, parameters: target.parameters)
            }, stubClosure: MoyaProvider.ImmediatelyStub))
        
        waitUntil(timeout: 30, action: { done in
            _ = gateway.getResource(target).subscribeError{ (error) in
                if let error = error as? WebRequestError{
                    recievedError = error
                }
                
                done()
            }
        })
        
        expect(recievedError).to(equal(WebRequestError.HTTPError(code: 401)))
    }
}