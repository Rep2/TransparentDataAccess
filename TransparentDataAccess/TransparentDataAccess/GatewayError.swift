import RxSwift

enum GatewayError: ErrorType {
    case HTTPError(code: Int)
    case UnboxingError
    case SystemError(code: Int, description: String)
    case PermissionDenied
    case NoDataReturned
    case NoDataFor(key: String)
    case CodingFailed

    var description: String {
        switch self {
        case .HTTPError(let code):
            return "HTTP error with status code \(code)"
        case .UnboxingError:
            return "Error while mapping response body"
        case .SystemError(_, let description):
            return description
        case .PermissionDenied:
            return "Permission was denied"
        case .NoDataReturned:
            return "Request returned no data"
        case .NoDataFor(let key):
            return "No data was found for key \(key)"
        case .CodingFailed:
            return "Resource coding failed"
        }

    }
}

extension GatewayError: Equatable {
}

func == (lhs: GatewayError, rhs: GatewayError) -> Bool {
    switch (lhs, rhs) {
    case (.NoDataFor(let x), .NoDataFor(let y)):
        return x == y
    case (.HTTPError(let x), .HTTPError(let y)):
        return x == y
    case (.UnboxingError, .UnboxingError):
        return true
    case (.SystemError(let x, _), .SystemError(let y, _)):
        return x == y
    case (.PermissionDenied, .PermissionDenied):
        return true
    case (.NoDataReturned, .NoDataReturned):
        return true
    case (.CodingFailed, .CodingFailed):
        return true
    default:
        return false
    }
}
