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

protocol ResourceTarget{
    var key: String { get }
}

enum ResourceTargetExample<R>{
    case EmptyTarget
    case Token(key: String, secret: String)
}

extension ResourceTargetExample: ResourceTarget{
    var key: String{
        switch self {
        case .EmptyTarget:
            return ""
        case .Token(let key, let secret):
            return key + "_" + secret
        }
    }
}

class GetGateway<R>{
    func getResource(resourceType: ResourceTargetExample<R>, forceRefresh: Bool = false) -> Observable<R>{
        return Observable.empty()
    }
}
