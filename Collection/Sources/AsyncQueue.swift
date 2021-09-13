public actor AsyncQueue<Value> {
    
    private var values: [Value]
    private var continuations: [CheckedContinuation<Value, Never>]
    
    public init() {
        self.values = [Value]()
        self.continuations = [CheckedContinuation<Value, Never>]()
    }
    
    public func enqueue(_ value: Value) {
        if !continuations.isEmpty {
            continuations.removeFirst().resume(returning: value)
        } else {
            values.append(value)
        }
    }
    
    public nonisolated func enqueue<Values>(_ values: Values) where Values: AsyncSequence, Values.Element == Value {
        Task {
            for try await value in values {
                await enqueue(value)
            }
        }
    }
    
    public func dequeue() async -> Value {
        if !values.isEmpty {
            return values.removeFirst()
        } else {
            return await withCheckedContinuation { continuation in
                continuations.append(continuation)
            }
        }
    }
    
    
    
}
