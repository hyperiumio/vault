public extension Range where Bound == Int {
    
    func moved(by count: Int) -> Self {
        return lowerBound + count ..< upperBound + count
    }
    
}
