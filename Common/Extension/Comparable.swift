extension Comparable {
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        guard self >= limits.lowerBound else {
            return limits.lowerBound
        }
        guard self <= limits.upperBound else {
            return limits.upperBound
        }
        
        return self
    }
    
}
