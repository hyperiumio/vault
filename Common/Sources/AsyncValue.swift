public actor AsyncValue<T> {
    
    private var state: State
    
    public init() {
        self.state = .waiting
    }
    
    public var value: T {
        get async {
            switch state {
            case .waiting:
                return await withCheckedContinuation { continuation in
                    let continuations = [continuation]
                    state = .valueRequested(continuations)
                }
            case .valueReceived(let value):
                return value
            case .valueRequested(let continuations):
                return await withCheckedContinuation { continuation in
                    let continuations = continuations + [continuation]
                    state = .valueRequested(continuations)
                }
            }
        }
    }
    
    public func set(_ value: T) async {
        switch state {
        case .waiting, .valueReceived:
            state = .valueReceived(value)
        case .valueRequested(let continuations):
            for continuation in continuations {
                continuation.resume(returning: value)
            }
            
            state = .valueReceived(value)
        }
    }
    
}

extension AsyncValue {
    
    enum State {
        
        case waiting
        case valueReceived(T)
        case valueRequested([CheckedContinuation<T, Never>])
        
    }
    
}
