//
//  ResourceMapper.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 01/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import RxSwift
import Moya
import Unbox

protocol ResourceMapperProtocol{
    func mapResponse<R: Unboxable>(observable: Observable<Response>, refreshesToken: Bool) -> Observable<R>
}

class ResourceMapper: ResourceMapperProtocol{
    
    let disposeBag = DisposeBag()
    
    func mapResponse<R: Unboxable>(observable: Observable<Response>, refreshesToken: Bool = true) -> Observable<R>{
        return observable
            .flatMap { (response) -> Observable<R> in
                return Observable.create({ (observer) -> Disposable in
                    if response.statusCode < 200 || response.statusCode >= 300{
                        
                        // If status code is 401 and refreshesToken is disabled return PermisionDenied error
                        if response.statusCode == 401 && !refreshesToken{
                            observer.onError(WebRequestError.PermissionDenied)
                        }
                            // Else propagate error
                        else{
                            observer.onError(WebRequestError.HTTPError(code: response.statusCode))
                        }
                        
                    }else{
                        do{
                            let resource: R = try Unbox(response.data)
                            
                            observer.onNext(resource)
                            observer.onCompleted()
                        }catch{
                            observer.onError(WebRequestError.UnboxingError)
                        }
                    }
                    
                    return NopDisposable.instance
                    }
                )
        }
    }
}