import Combine

protocol Completable: class {
    
    associatedtype Completion
    
    var completionPromise: Future<Completion, Never>.Promise? { get set }
    
    func completion() -> Future<Completion, Never>
    
}

extension Completable {
    
    func completion() -> Future<Completion, Never> {
        return Future { [weak self] promise in
            self?.completionPromise = promise
        }
    }
    
}
