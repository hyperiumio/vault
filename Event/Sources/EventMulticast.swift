import Combine

public actor EventMulticast<Event> {
    
    private let publisher = PassthroughSubject<Event, Never>()
    
    public init() {
        
    }
    
    public nonisolated func send(_ event: Event) {
        publisher.send(event)
    }
    
    public nonisolated func finish() {
        publisher.send(completion: .finished)
    }
    
    public nonisolated var events: AsyncStream<Event> {
        AsyncStream { continuation in
            Task {
                for await value in publisher.values {
                    continuation.yield(value)
                }
            }
        }
    }
    
}
