import XCTest
@testable import Store

class RangeExtensionTests: XCTestCase {
    
    func testZeroCount() {
        let range = Range(1, count: 0)
        
        XCTAssertEqual(range.count, 0)
    }
    
    func testLowerBoundAndUpperbound() {
        let range = Range(1, count: 2)
        
        XCTAssertEqual(range.lowerBound, 1)
        XCTAssertEqual(range.upperBound, 3)
    }
    
}
