extension Result where Success == Void {
    
    static var success: Self {
        return Self.success(())
    }
    
}
