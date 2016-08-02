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
    func mapResponse<R: Unboxable>(observable: Observable<Response>, tokenRefreshed:Bool) -> Observable<R>
}

class ResourceMapper: ResourceMapperProtocol{
    
    let disposeBag = DisposeBag()
    
    func mapResponse<R: Unboxable>(observable: Observable<Response>, tokenRefreshed:Bool = false) -> Observable<R>{
        return Observable.create({ (observer) -> Disposable in
            observable.subscribe(
                onNext: { (response) in
                    if response.statusCode < 200 || response.statusCode >= 300{
                        observer.onError(WebRequestError.HTTPError(code: response.statusCode))
                    }else{
                        do{
                            let resource: R = try Unbox(response.data)
                            
                            observer.onNext(resource)
                            observer.onCompleted()
                        }catch{
                            observer.onError(WebRequestError.UnboxingError)
                        }
                    }
                }, onError: { (error) in
                    observer.onError(error)
                }, onCompleted: {
                    observer.onCompleted()
                }
            ).addDisposableTo(self.disposeBag)
            
            
            return NopDisposable.instance
        })
    }
}