extension Range where Bound == Int {
    
    init(lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}
