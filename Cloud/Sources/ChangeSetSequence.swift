import Foundation

public struct ChangeSetSequence: AsyncSequence {
    
    public typealias Element = ChangeSet
    
    let body: (_ send: @escaping (Event) -> Void) -> Void
    
    public func makeAsyncIterator() -> Iterator {
        let iterator = Iterator()
        body(iterator.apply)
        return iterator
    }
    
}

extension ChangeSetSequence {
    
    enum Event {
        
        case value(ChangeSet)
        case finished
        case failure(Error)
        
    }
    
    public class Iterator: AsyncIteratorProtocol {
        
        private let queue = DispatchQueue(label: "ChangeSetSequenceIteratorQueue")
        private var changeSets = [ChangeSet]()
        private var continuations = [CheckedContinuation<ChangeSet?, Error>]()
        private var completion: Result<Void, Error>?
        
        func apply(_ event: Event) {
            queue.sync {
                switch event {
                case .value(let changeSet):
                    if let continuation = continuations.popLast() {
                        continuation.resume(returning: changeSet)
                    } else {
                        changeSets.append(changeSet)
                    }
                case .finished:
                    if let continuation = continuations.popLast() {
                        continuation.resume(returning: nil)
                    }
                    completion = .success(())
                case .failure(let error):
                    if let continuation = continuations.popLast() {
                        continuation.resume(throwing: error)
                    }
                    completion = .success(())
                }
            }
        }
        
        public func next() async throws -> ChangeSet? {
            try await withCheckedThrowingContinuation { [queue] continuation in
                queue.sync {
                    switch completion {
                    case .success:
                        continuation.resume(returning: nil)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case nil:
                        if let changeSet = changeSets.popLast() {
                            continuation.resume(returning: changeSet)
                        } else {
                            continuations.append(continuation)
                        }
                    }
                }
            }
        }
        
    }
    
}