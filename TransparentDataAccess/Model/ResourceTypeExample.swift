//
//  ResourceTypeExample.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation

enum ResourceTypeExample{
    case EmptyTarget
    case Token(key: String, secret: String)
}

extension ResourceTypeExample: StorableType{
    var key: String{
        switch self {
        case .EmptyTarget:
            return ""
        case .Token(let key, let secret):
            return key + "_" + secret
        }
    }
}