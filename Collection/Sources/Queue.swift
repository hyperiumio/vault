public actor Queue<T> {
    
    private var values: [T]
    private var continuations: [CheckedContinuation<T, Never>]
    
    public init() {
        self.values = [T]()
        self.continuations = [CheckedContinuation<T, Never>]()
    }
    
    public func enqueue(_ value: T) {
        values.append(value)
        
        while !values.isEmpty, !continuations.isEmpty {
            let value = values.removeFirst()
            let continuation = continuations.removeFirst()
            continuation.resume(returning: value)
        }
    }
    
    public func dequeue() async -> T {
        await withCheckedContinuation { continuation in
            continuations.append(continuation)
            
            while !values.isEmpty, !continuations.isEmpty {
                let value = values.removeFirst()
                let continuation = continuations.removeFirst()
                continuation.resume(returning: value)
            }
        }
    }
}
