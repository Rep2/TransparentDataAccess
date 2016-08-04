//
//  WebGateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Unbox

enum WebRequestError: ErrorType{
    case HTTPError(code: Int)
    case UnboxingError
}

extension WebRequestError: Equatable{
}

func ==(lhs: WebRequestError, rhs: WebRequestError) -> Bool{
    switch (lhs, rhs) {
    case (.HTTPError(let x), .HTTPError(let y)):
        return x == y
    case (.UnboxingError, .UnboxingError):
        return true
    default:
        return false
    }
}

class WebGateway<R: Unboxable, T: ResourceType>: GetGateway<R, T>{
    let provider: RxMoyaProvider<T>
    let mapper: ResourceMapperProtocol
    
    init(provider: RxMoyaProvider<T> = RxMoyaProvider<T>(), mapper: ResourceMapperProtocol = ResourceMapper()){
        self.provider = provider
        self.mapper = mapper
    }
    
    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return mapper.mapResponse(provider.request(resourceType)
            .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))))
            .catchError({ (error) -> Observable<R> in
                if let error = error as? WebRequestError{
                    if error == WebRequestError.HTTPError(code: 401) && !forceRefresh{
                        // TODO refresh token
                        
                        self.getResource(resourceType, forceRefresh: true)
                    }
                }
                
                return Observable.error(error)
            })
    }
}