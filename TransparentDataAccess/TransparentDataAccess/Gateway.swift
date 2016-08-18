import RxSwift
import Unbox
import Moya


protocol ResourceType: TargetType, StorableType {
}

extension ResourceType {

    var baseURL: NSURL { return NSURL(string: "")! }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .GET
    }

    var parameters: [String: AnyObject]? {
        return nil
    }

    var multipartBody: [MultipartFormData]? {
        return nil
    }

    var sampleData: NSData {
        return "".dataUsingEncoding(NSUTF8StringEncoding)!
    }

    var key: String {
        return ""
    }
}

protocol StorableType {
    var key: String { get }
}

class GetGateway<R, T> {
    func getResource(resourceType: T, forceRefresh: Bool = false) -> Observable<R> {
        return Observable.empty()
    }
}

class GetSetGateway<R, T: StorableType>: GetGateway<R, T> {
    func setResource(resourceType: T, resource: R) {
    }
}

extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    var UTF8EncodedData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}
