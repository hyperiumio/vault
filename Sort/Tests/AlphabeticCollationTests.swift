import XCTest
@testable import Sort

final class AlphabeticCollationTests: XCTestCase {
    
    func testEmptyCollation() {
        let collation = AlphabeticCollation<AlphabeticCollationElementStub>()
        
        XCTAssertTrue(collation.sections.isEmpty)
    }
    
    func testEmptySectionKey() throws {
        let elements = [
            AlphabeticCollationElementStub(value: "")
        ]
        let sectionIDs = AlphabeticCollation(from: elements).sections.map(\.id)
        
        let expectedIDs = [""]
        
        XCTAssertEqual(sectionIDs, expectedIDs)
    }
    
    func testSectionKeyUppercase() {
        let elements = [
            AlphabeticCollationElementStub(value: "a")
        ]
        let collation = AlphabeticCollation(from: elements)
        let sectionKeys = collation.sections.map(\.key)
        
        let expectedKeys = ["A"]
        
        XCTAssertEqual(sectionKeys, expectedKeys)
    }
    
    func testSectionKeyOrder() {
        let elements = [
            AlphabeticCollationElementStub(value: "ba"),
            AlphabeticCollationElementStub(value: "ab"),
        ]
        let sectionKeys = AlphabeticCollation(from: elements).sections.map(\.key)
        
        let expectedKeys = ["A", "B"]
        
        XCTAssertEqual(sectionKeys, expectedKeys)
    }
    
    func testSectionElements() {
        let elements = [
            AlphabeticCollationElementStub(value: "ab"),
            AlphabeticCollationElementStub(value: "ac"),
            AlphabeticCollationElementStub(value: "ba")
        ]
        let sectionElementCounts = AlphabeticCollation(from: elements).sections.map { section in
            section.elements.count
        }
        let expectedElementCounts = [2, 1]
        
        XCTAssertEqual(sectionElementCounts, expectedElementCounts)
    }
    
    func testSectionElementsOrder() {
        let elements = [
            AlphabeticCollationElementStub(value: "ab"),
            AlphabeticCollationElementStub(value: "aa")
        ]
        let sectionElements = AlphabeticCollation(from: elements).sections.flatMap { section in
            section.elements.map(\.value)
        }
        let expectedElements = ["aa", "ab"]
        
        XCTAssertEqual(sectionElements, expectedElements)
    }
    
}

private struct AlphabeticCollationElementStub: AlphabeticCollationElement {
    
    let value: String
    
    var sectionKey: String {
        let firstCharacter = value.prefix(1)
        return String(firstCharacter)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
}
