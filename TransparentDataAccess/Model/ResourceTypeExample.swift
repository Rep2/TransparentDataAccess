enum ResourceTargetExample{
    case EmptyTarget
    case Token(key: String, secret: String)
}

extension ResourceTargetExample: StorableTarget{
    var key: String{
        switch self {
        case .EmptyTarget:
            return ""
        case .Token(let key, let secret):
            return key + "_" + secret
        }
    }
}