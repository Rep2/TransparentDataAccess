//
//  GitHubTarget.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import RxSwift
import Moya
import Unbox

public enum GitHub {
    case UserProfile(String)
}

extension GitHub: ResourceType {
    public var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .UserProfile(let name):
            return "/users/\(name.URLEscapedString)"
        }
    }
    public var method: Moya.Method {
        return .GET
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        case .UserProfile:
            return nil
        }
    }
    public var multipartBody: [MultipartFormData]?{
        return nil
    }
    public var sampleData: NSData {
        switch self {
        case .UserProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}