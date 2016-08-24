import RxSwift
import Unbox
import Alamofire

public enum GitHub {
    case UserProfile(String)
}

extension GitHub: WebTarget, StorableTarget {
    static let baseURLString = "https://api.github.com"
    static var OAuthToken: String?

    public var path: String {
        switch self {
        case .UserProfile(let name):
            return "/users/\(name.URLEscapedString)"
        }
    }

    public var method: Alamofire.Method {
        return .GET
    }

    public var URLRequest: NSMutableURLRequest {
        print("reqeust")
        let URL = NSURL(string: GitHub.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        switch self {
        case .UserProfile(_):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
    }

    var key: String {
        switch self {
        case .UserProfile(let name):
            return name
        }
    }
}