import XCTest
@testable import Search

final class MatchTests: XCTestCase {
    
    func testEmptyPattern() {
        let matches = Match("", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testEmptyPatternEmptyString() {
        let matches = Match("", in: "")
        
        XCTAssertTrue(matches)
    }
    
    func testPatternLongerThanString() {
        let matches = Match("abc", in: "ab")
        
        XCTAssertFalse(matches)
    }
    
    func testPatternEqualToString() {
        let matches = Match("abc", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchFirstCharacter() {
        let matches = Match("a", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchAnyCharacter() {
        let matches = Match("b", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testMatchLastCharacter() {
        let matches = Match("c", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testPartitialMatchesWithGaps() {
        let matches = Match("ac", in: "abc")
        
        XCTAssertTrue(matches)
    }
    
    func testPartitialMatchesWithMismatch() {
        let matches = Match("adc", in: "abc")
        
        XCTAssertFalse(matches)
    }
    
    func testUppercasePatternLowercaseString() {
        let matches = Match("A", in: "a")
        
        XCTAssertTrue(matches)
    }
    
    func testLowercasePatternUppercaseString() {
        let matches = Match("a", in: "A")
        
        XCTAssertTrue(matches)
    }
    
}
