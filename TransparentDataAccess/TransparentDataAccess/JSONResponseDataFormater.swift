//
//  File.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 03/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation

func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =
            try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}
