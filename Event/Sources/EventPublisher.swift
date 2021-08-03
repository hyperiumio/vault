public actor EventPublisher<Event> {
    
    private var continuations: [AsyncStream<Event>.Continuation]
    
    public init() {
        self.continuations = [AsyncStream<Event>.Continuation]()
    }
    
    public var events: AsyncStream<Event> {
        AsyncStream { continuation in
            continuations.append(continuation)
        }
    }
    
    public func send(_ event: Event) {
        for continuation in continuations {
            continuation.yield(event)
        }
    }
    
    deinit {
        for continuation in continuations {
            continuation.finish()
        }
    }
    
}

