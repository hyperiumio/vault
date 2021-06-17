import Foundation

public struct ValueSequence<T>: AsyncSequence {
    
    public typealias Element = T
    
    let body: (_ send: @escaping (Event) -> Void) -> Void
    
    public func makeAsyncIterator() -> Iterator {
        let iterator = Iterator()
        body(iterator.apply)
        return iterator
    }
    
}

extension ValueSequence {
    
    enum Event {
        
        case value(T)
        case finished
        case failure(Error)
        
    }
    
    public class Iterator: AsyncIteratorProtocol {
        
        private let queue = DispatchQueue(label: "ChangeSetSequenceIteratorQueue")
        private var changeSets = [T]()
        private var continuations = [CheckedContinuation<T?, Error>]()
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
        
        public func next() async throws -> T? {
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
