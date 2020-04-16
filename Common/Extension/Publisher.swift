import Combine

extension Publisher {
    
    func result() -> AnyPublisher<Result<Self.Output, Self.Failure>, Never> {
        return self
            .map { value in
                return Result.success(value)
            }
            .catch { error in
                return Just(Result.failure(error))
            }
            .eraseToAnyPublisher()
    }
    
}
