//
//  TwitterAccessToken.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import Unbox

class TwitterAccessToken: Unboxable, Keychainable{
    let token: String
    
    required init(unboxer: Unboxer) {
        self.token = unboxer.unbox("token")
    }
    
    required init(data: String){
        self.token = data
    }
    
    func toString() -> String {
        return self.token
    }
}