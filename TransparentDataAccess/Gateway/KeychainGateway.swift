//
//  KeychainGateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift

protocol Keychainable{
    init(data: String)
    
    func toString() -> String
}

let keychainServiceString = "undabot.TransparentDataAccess"
let keychain = Keychain(service: keychainServiceString)

class KeychainGateway<R: Keychainable, T: ResourceType>: GetSetGateway<R, T>{
    private let keychainKey = "TwitterAccessToken"
    
    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R>{
        let resourceString = keychain[resourceType.key]
        
        if resourceString != nil && !forceRefresh{
            return Observable.just(R(data: resourceString!))
        } else {
            return Observable.error(GatewayError.NoDataFor(key: resourceType.key))
        }
    }
    
    override func setResource(resourceType: T, resource: R){
        keychain[resourceType.key] = resource.toString()
    }
}