import Combine

extension Publisher {
    
    func result(receiveResult: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        
        func receiveCompletion(completion: Subscribers.Completion<Failure>) {
            if case .failure(let error) = completion {
                let failure = Result<Output, Failure>.failure(error)
                receiveResult(failure)
            }
        }
        
        func receiveValue(value: Output) {
            let success = Result<Output, Failure>.success(value)
            receiveResult(success)
        }
        
        return sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
    
}
