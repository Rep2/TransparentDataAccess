//
//  CodingGateway.swift
//  TransparentDataAccess
//
//  Created by Undabot Rep on 09/08/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

enum CodingGatewayStorables: StorableType {
    case SearchQueries
    case TestObject

    var key: String {
        switch self {
        case .SearchQueries:
            return "queries"
        case .TestObject:
            return "test_object"
        }
    }
}

enum CodingGatewayError: ErrorType {
    case NoDataForKey(key: String)
    case CodingFailed
}

class CodingGateway<R: NSCoding, T: StorableType>: GetSetGateway<R, T> {

    override func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.create({ (observer) -> Disposable in
            if let data = NSUserDefaults.standardUserDefaults().objectForKey(resourceType.key) as? NSData {
                if let resource = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? R {
                    observer.onNext(resource)
                    observer.onCompleted()
                } else {
                    observer.onError(CodingGatewayError.CodingFailed)
                }
            } else {
                observer.onError(CodingGatewayError.NoDataForKey(key: resourceType.key))
            }

            return NopDisposable.instance
        })
    }

    override func setResource(resourceType: T, resource: R) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(resource)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: resourceType.key)
    }
}
