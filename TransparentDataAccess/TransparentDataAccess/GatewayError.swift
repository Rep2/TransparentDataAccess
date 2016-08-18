enum GatewayError: ErrorType {
    case NoDataFor(key: String)
}

extension GatewayError: Equatable {
}

func == (lhs: GatewayError, rhs: GatewayError) -> Bool {
    switch (lhs, rhs) {
    case (.NoDataFor(let x), .NoDataFor(let y)):
        return x == y
    }
}
