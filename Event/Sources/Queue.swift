actor Queue<Value> {
    
    private var values = [Value]()
    private var continuations = [CheckedContinuation<Value, Never>]()
    
    func enqueue(_ event: Value) {
        if !continuations.isEmpty {
            continuations.removeFirst().resume(returning: event)
        } else {
            values.append(event)
        }
    }
    
    func dequeue() async -> Value {
        if !values.isEmpty {
            return values.removeFirst()
        } else {
            return await withCheckedContinuation { continuation in
                continuations.append(continuation)
            }
        }
    }
    
}
