extension Range where Bound == Int {
    
    init(lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
    func moved(by count: Int) -> Self {
        return lowerBound + count ..< upperBound + count
    }
    
}
