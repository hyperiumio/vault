import XCTest

class SaltTestCase: XCTestCase {

    func testRandomNumberGeneratorFailure() {
        let rngBytes = [UInt8]()
        let rng = RNGStub(result: CryptoFailure, bytes: rngBytes)
        
        XCTAssertThrowsError(try Salt(size: 0, rng: rng)) { error in
            XCTAssertEqual(error as? Salt.Error, .randomNumberGeneratorFailure)
        }
    }

    func testZeroCount() throws {
        let rngBytes = [UInt8]()
        let rng = RNGStub(result: CryptoSuccess, bytes: rngBytes)
        
        try Salt(size: 0, rng: rng).withUnsafeBytes { salt in
            XCTAssertEqual(salt.count, 0)
        }
    }

    func testEveryByteValue() throws {
        let rngBytes = Array(0 ... UInt8.max)
        let rng = RNGStub(result: CryptoSuccess, bytes: rngBytes)

        try Salt(size: rngBytes.count, rng: rng).withUnsafeBytes { salt in
            let resultBytes = Array(salt)
            XCTAssertEqual(resultBytes, rngBytes)
        }
    }
    
}
