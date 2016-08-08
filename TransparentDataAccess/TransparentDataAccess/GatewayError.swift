//
//  GatewayError.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation

enum GatewayError: ErrorType {
    case NoDataFor(key: String)
}

extension GatewayError: Equatable {
}

func == (lhs: GatewayError, rhs: GatewayError) -> Bool {
    switch (lhs, rhs) {
    case (.NoDataFor(let x), .NoDataFor(let y)):
        return x == y
    }
}
