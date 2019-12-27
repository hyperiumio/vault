import XCTest

class DataExtensionTestCase: XCTestCase {

    func testExpressibleByIntegerLiteralAllValues() {
        for value in 0 ... UInt8.max {
            let data = Data(integerLiteral: value)
            let expectedBytes = [value]
            let expectedData = Data(expectedBytes)
            
            XCTAssertEqual(data, expectedData)
        }
    }
    
    func testExpressibleByStringLiteralEmptyString() {
        let data = "" as Data

        XCTAssertEqual(data.count, 0)
    }

    func testExpressibleByStringLiteralUnevenCharacterCount() {
        XCTAssertEqual("0" as Data, 0 as Data)
        XCTAssertEqual("1" as Data, 1 as Data)
        XCTAssertEqual("2" as Data, 2 as Data)
        XCTAssertEqual("3" as Data, 3 as Data)
        XCTAssertEqual("4" as Data, 4 as Data)
        XCTAssertEqual("5" as Data, 5 as Data)
        XCTAssertEqual("6" as Data, 6 as Data)
        XCTAssertEqual("7" as Data, 7 as Data)
        XCTAssertEqual("8" as Data, 8 as Data)
        XCTAssertEqual("9" as Data, 9 as Data)
        XCTAssertEqual("A" as Data, 10 as Data)
        XCTAssertEqual("B" as Data, 11 as Data)
        XCTAssertEqual("C" as Data, 12 as Data)
        XCTAssertEqual("D" as Data, 13 as Data)
        XCTAssertEqual("E" as Data, 14 as Data)
        XCTAssertEqual("F" as Data, 15 as Data)
    }

    func testExpressibleByStringLiteralEveryHexValue() {
        let data = "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7F808182838485868788898A8B8C8D8E8F909192939495969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8D9DADBDCDDDEDFE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF" as Data
        let expectedData = Data(0 ... UInt8.max)

        XCTAssertEqual(data, expectedData)
    }

}
