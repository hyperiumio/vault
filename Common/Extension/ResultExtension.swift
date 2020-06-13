extension Result where Failure == Never {
    
    static func success(value: Success) -> Self {
        return .success(value)
    }
    
}
