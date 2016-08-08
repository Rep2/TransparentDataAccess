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

enum WebRequestError: ErrorType {
    case HTTPError(code: Int)
    case UnboxingError
    case SystemError(code: Int, description: String)
    case PermissionDenied
    case NoDataReturned
}

extension WebRequestError: Equatable {
}

func == (lhs: WebRequestError, rhs: WebRequestError) -> Bool {
    switch (lhs, rhs) {
    case (.HTTPError(let x), .HTTPError(let y)):
        return x == y
    case (.UnboxingError, .UnboxingError):
        return true
    case (.PermissionDenied, .PermissionDenied):
        return true
    case (.NoDataReturned, .NoDataReturned):
        return true
    default:
        return false
    }
}

/// Generic web request error display
extension UIViewController {
    func displayWebRequestError(error: ErrorType) {
        if let error = error as? WebRequestError {
            switch error {
            case .SystemError(_, let description):
                presentAlert(description)
            default:
                presentAlert("Timeline get failed with error: \(error)")
            }
        } else {
            presentAlert("Timeline get failed with error: \(error)")
        }
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String? = nil, buttonTitle: String? = nil) {
        let alertController: UIAlertController

        alertController = UIAlertController(title:title,
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.ActionSheet)

        alertController.addAction(UIAlertAction(title: buttonTitle ?? "OK", style: UIAlertActionStyle.Cancel, handler: nil))

        self.presentViewController(alertController, animated:true, completion: nil)
    }
}


class WebGateway<R: Unboxable, T: ResourceType>: GetGateway<R, T> {
    var provider: RxMoyaProvider<T>!
    let mapper: ResourceMapperProtocol

    init(provider: RxMoyaProvider<T>? =
        RxMoyaProvider<T>(), mapper: ResourceMapperProtocol = ResourceMapper()) {
        self.provider = provider
        self.mapper = mapper
    }

    override final func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return createProvider()
            .flatMap({ (provider) -> Observable<R> in

                // Mapps response to object with token refresh enabled
                self.mapper.mapResponse(
                    // Calls Moya
                    provider.request(resourceType)
                        .observeOn(ConcurrentDispatchQueueScheduler(
                            queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))),
                    // Indicates that token refresh is enabled
                    refreshesToken: true)

                    // Catch 401 errors and automaticaly try to refresh token
                    // if forceRefresh is false
                    .catchError({ (error) -> Observable<R> in

                        if let error = error as? WebRequestError {
                            if error == WebRequestError.HTTPError(code: 401) {
                                // Refresh token

                                
                                return self.createProvider()
                                    .flatMap({ (newProvider) -> Observable<R> in

                                        // Mapps response to object with token
                                        // refresh disabled
                                        return self.mapper.mapResponse(
                                            // Calls Moya
                                            newProvider.request(resourceType)
                                                .observeOn(ConcurrentDispatchQueueScheduler(
                                                    queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))),
                                            // Indicates that token refresh is disabled
                                            refreshesToken: false)
                                    })

                            }
                        }



                        return Observable.error(error)
                    })
            })
    }

    func createProvider() -> Observable<RxMoyaProvider<T>> {
        return Observable.just(provider)
    }
}
