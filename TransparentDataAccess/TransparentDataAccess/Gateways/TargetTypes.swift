import Alamofire
import RxSwift

protocol StorableTarget {
    var key: String { get }
}

protocol WebTarget: URLRequestConvertible {
}

protocol ResourceTarget: StorableTarget, WebTarget {
}

protocol RefreshableTarget: ResourceTarget {
    func setToken(token: String) -> Self
}
