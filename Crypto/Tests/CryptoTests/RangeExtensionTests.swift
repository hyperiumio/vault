import XCTest
@testable import Crypto

class RangeExtensionTests: XCTestCase {
    
    func testZeroCount() {
        let range = Range(lowerBound: 0, count: 0)
        
        XCTAssertEqual(range.count, 0)
    }
    
    func testLowerBoundAndUpperbound() {
        let range = Range(lowerBound: 1, count: 2)
        
        XCTAssertEqual(range.lowerBound, 1)
        XCTAssertEqual(range.upperBound, 3)
    }
    
}
