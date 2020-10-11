import Foundation

extension Range where Bound == Int {
    
    init(_ lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}
