//
//  Gateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import RxSwift
import Unbox
import Moya


protocol ResourceType: TargetType, StorableType {
}

extension ResourceType {

    var baseURL: NSURL { return NSURL(string: "")! }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .GET
    }

    var parameters: [String: AnyObject]? {
        return nil
    }

    var multipartBody: [MultipartFormData]? {
        return nil
    }

    var sampleData: NSData {
        return "".dataUsingEncoding(NSUTF8StringEncoding)!
    }

    var key: String {
        return ""
    }
}

protocol StorableType {
    var key: String { get }
}

class GetGateway<R, T: ResourceType> {
    func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.empty()
    }
}

class GetSetGateway<R, T: ResourceType>: GetGateway<R, T> {
    func setResource(resourceType: T, resource: R) {
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}
