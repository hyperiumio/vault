import XCTest
@testable import Search

final class FuzzyMatchTests: XCTestCase {
    
    func testEmptyPattern() {
        let matches = FuzzyMatch("", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testEmptyPatternEmptyString() {
        let matches = FuzzyMatch("", in: "")
        
        XCTAssertTrue(matches)
    }
    
    func testPatternLongerThanString() {
        let matches = FuzzyMatch("abc", in: "ab")
        
        XCTAssertFalse(matches)
    }
    
    func testPatternEqualToString() {
        let matches = FuzzyMatch("abc", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchFirstCharacter() {
        let matches = FuzzyMatch("a", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchAnyCharacter() {
        let matches = FuzzyMatch("b", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchLastCharacter() {
        let matches = FuzzyMatch("c", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testPartitialMatchesWithGaps() {
        let matches = FuzzyMatch("ac", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testPartitialMatchesWithMismatch() {
        let matches = FuzzyMatch("adc", in: "abc")
        
        XCTAssertFalse(matches)
    }
    
    func testUppercasePatternLowercaseString() {
        let matches = FuzzyMatch("A", in: "a")
        
        XCTAssertTrue(matches)
    }
    
    func testLowercasePatternUppercaseString() {
        let matches = FuzzyMatch("a", in: "A")
        
        XCTAssertTrue(matches)
    }
    
}
