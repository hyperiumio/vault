extension Result where Success == Void {
    
    static var success: Self {
        return Self.success(())
    }
    
}

extension Result where Failure == Never {
    
    static func success(value: Success) -> Self {
        return .success(value)
    }
    
}
