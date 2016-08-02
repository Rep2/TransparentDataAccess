//
//  CompositeLocalAndWebTest.swift
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

class CompositeLocalAndWebGatewayTest: XCTestCase{
    
    func test_LocalAndWebComposite_WebData(){
        let firstGateway = LocalGateway<UserProfile, GitHub>()
        let secondGateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider.init(
            endpointClosure: { (target) -> Endpoint<GitHub> in
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                return Endpoint<GitHub>(URL: url, sampleResponseClosure: {.NetworkResponse(400, target.sampleData)}, method: target.method, parameters: target.parameters)
            }, stubClosure: MoyaProvider.ImmediatelyStub))
        
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedProfile: UserProfile?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(GitHub.UserProfile("Rep2"))
                .subscribe(
                    onNext: { (profile) in
                        recievedProfile = profile
                    }, onDisposed: {
                        done()
                })
        })
    
        expect(recievedProfile).to(beNil())
    }
    
    func test_LocalAndWebComposite_DataInFirst(){
        let profile = UserProfile()
        let type = GitHub.UserProfile("Rep2")
        
        let firstGateway = LocalGateway<UserProfile, GitHub>(resources: [type.key : profile])
        let secondGateway = WebGateway<UserProfile, GitHub>(provider: RxMoyaProvider.init(
            endpointClosure: { (target) -> Endpoint<GitHub> in
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                return Endpoint<GitHub>(URL: url, sampleResponseClosure: {.NetworkResponse(400, target.sampleData)}, method: target.method, parameters: target.parameters)
            }, stubClosure: MoyaProvider.ImmediatelyStub))
        
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedProfile: UserProfile?
        
        waitUntil(action: { done in
            _ = compositGateway.getResource(type)
                .subscribeNext { (profile) in
                    recievedProfile = profile
                    done()
            }
        })
        
        expect(recievedProfile).toNot(beNil())
    }
    
    func test_LocalAndWebComposite_DataInSecond(){
        let type = GitHub.UserProfile("Rep2")
        
        let firstGateway = LocalGateway<UserProfile, GitHub>()
        let secondGateway = WebGateway<UserProfile, GitHub>()
        let compositGateway = CompositGateway(gateways: [firstGateway, secondGateway])
        
        var recievedProfile: UserProfile?
        
        waitUntil(timeout: 10, action: { done in
            _ = compositGateway.getResource(type)
                .subscribeNext { (profile) in
                    recievedProfile = profile
                    done()
            }
        })
        
        expect(recievedProfile).toNot(beNil())
    }
    
    
}