//
//  EmptyModel.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import Unbox

class SimpleModel: Unboxable, Keychainable{
    
    var data: String
    
    required init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
    }
    
    required init(data: String){
        self.data = data
    }
    
    func toString() -> String {
        return self.data
    }
}