//
//  GitHubTargets.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 02/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import Unbox

struct UserProfile: Unboxable{
    let name: String
    let email: String
    let login: String
    
    init(unboxer: Unboxer) {
        self.name = unboxer.unbox("name")
        self.email = unboxer.unbox("email")
        self.login = unboxer.unbox("login")
    }
}
