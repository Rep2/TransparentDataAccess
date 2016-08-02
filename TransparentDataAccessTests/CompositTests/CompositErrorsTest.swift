//
//  CompositErrorsTest.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Nimble
import Moya
@testable import TransparentDataAccess

class CompositeErrorsTest: XCTestCase{
    
    func test_ErrorOfLastGateway_LocalNoData(){
        let target = GitHub.UserProfile("Rep2")
        
        let firstGateway = LocalGateway<UserProfile, GitHub>()
        
        let compositGateway = CompositGateway(gateways: [firstGateway])
        
        var recievedError: GatewayError?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(target)
                .subscribe(
                    onError: { (error) in
                        if let error = error as? GatewayError{
                            recievedError = error
                        }
                    }, onDisposed: {
                        done()
                })
        })
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_ErrorOfLastGateway_KeychainNoData(){
        let target = ResourceTypeExample.Token(key: "empty key", secret: "secret")
        
        let firstGateway = LocalGateway<TwitterAccessToken, ResourceTypeExample>()
        let secondGateway = KeychainGateway<TwitterAccessToken, ResourceTypeExample>()
        
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedError: GatewayError?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(target)
                .subscribe(
                    onError: { (error) in
                        if let error = error as? GatewayError{
                            recievedError = error
                        }
                    }, onDisposed: {
                        done()
                })
        })
        
        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }
    
    func test_ErrorOfLastGateway_WebError(){
        let type = GitHub.UserProfile("Rep2")
        
        let firstGateway = LocalGateway<UserProfile, GitHub>()
        let secondGateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider.init(
            endpointClosure: { (target) -> Endpoint<GitHub> in
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                return Endpoint<GitHub>(URL: url, sampleResponseClosure: {.NetworkResponse(400, target.sampleData)}, method: target.method, parameters: target.parameters)
            }, stubClosure: MoyaProvider.ImmediatelyStub))
        
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedError: WebRequestError?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(type)
                .subscribe(
                    onError: { (error) in
                        if let error = error as? WebRequestError{
                            recievedError = error
                        }
                    }, onDisposed: {
                        done()
                })
        })
        
        expect(recievedError).to(equal(WebRequestError.HTTPError(code: 400)))
    }
}