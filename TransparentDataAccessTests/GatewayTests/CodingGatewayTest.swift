//
//  CodingGatewayTest.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 09/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import RxSwift
import Moya
@testable import TransparentDataAccess

class CodingGatewayTest: XCTestCase{

    func test_SetGet_Successful(){
        let gateway = CodingGateway<SearchQueries, CodingGatewayStorables>()
        let testQueries = SearchQueries(searchQueries: [SearchQuery(name: "test name", query: "query", inUse: false)])
        var recievedQueries: SearchQueries?

        gateway.setResource(.SearchQueries, resource: testQueries)

        _ = gateway.getResource(.SearchQueries)
            .subscribeNext { (query) in
                recievedQueries = query
        }

        expect(recievedQueries).toNot(beNil())
        expect(recievedQueries?.searchQueries[0].name).to(equal(testQueries.searchQueries[0].name))
    }

    func test_SetGet_Unsuccessful(){
        let gateway = CodingGateway<SearchQueries, CodingGatewayStorables>()
        var recievedQueries: SearchQueries?

        _ = gateway.getResource(.TestObject)
            .subscribeNext { (query) in
                recievedQueries = query
        }

        expect(recievedQueries).to(beNil())
    }

}
