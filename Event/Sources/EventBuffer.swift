public actor EventBuffer<Event> {
    
    public nonisolated let events: AsyncStream<Event>
    private let queue: Queue<Event>
    
    public init() {
        let queue = Queue<Event>()
        let events = AsyncStream(unfolding: queue.dequeue)
        
        self.queue = queue
        self.events = events
    }
    
    public nonisolated func enqueue(_ value: Event) {
        Task {
            await queue.enqueue(value)
        }
    }
    
    public nonisolated func enqueue<Values>(_ values: Values) where Values: AsyncSequence, Values.Element == Event {
        Task {
            for try await value in values {
                await queue.enqueue(value)
            }
        }
    }
    
}
