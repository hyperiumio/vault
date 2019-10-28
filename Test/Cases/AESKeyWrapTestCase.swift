import CryptoKit
import XCTest

class AESKeyWrapTestCase: XCTestCase {

    let key128Bit = SymmetricKey(data: "00112233445566778899AABBCCDDEEFF" as Data)
    let key192Bit = SymmetricKey(data: "00112233445566778899AABBCCDDEEFF0001020304050607" as Data)
    let key256Bit = SymmetricKey(data: "00112233445566778899AABBCCDDEEFF000102030405060708090A0B0C0D0E0F" as Data)

    let keyEncryptionKey128Bit = SymmetricKey(data: "000102030405060708090A0B0C0D0E0F" as Data)
    let keyEncryptionKey192Bit = SymmetricKey(data: "000102030405060708090A0B0C0D0E0F1011121314151617" as Data)
    let keyEncryptionKey256Bit = SymmetricKey(data: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F" as Data)

    let wrappedKey128BitKeyEncryptionKey128Bit = "1FA68B0A8112B447AEF34BD8FB5A7B829D3E862371D2CFE5" as Data
    let wrappedKey128BitKeyEncryptionKey192Bit = "96778B25AE6CA435F92B5B97C050AED2468AB8A17AD84E5D" as Data
    let wrappedKey128BitKeyEncryptionKey256Bit = "64E8C3F9CE0F5BA263E9777905818A2A93C8191E7D6E8AE7" as Data
    let wrappedKey192BitKeyEncryptionKey192Bit = "031D33264E15D33268F24EC260743EDCE1C6C7DDEE725A936BA814915C6762D2" as Data
    let wrappedKey192BitKeyEncryptionKey256Bit = "A8F9BC1612C68B3FF6E6F4FBE30E71E4769C8B80A32CB8958CD5D17D6B254DA1" as Data
    let wrappedKey256BitKeyEncryptionKey256Bit = "28C9F404C4B810F4CBCCB35CFB87F8263F5786E2D80ED326CBC7F0E71A99F43BFB988B9B7A02DD21" as Data
    
    func testWrappedKeySize128Bit() {
        let wrappedKeySize = AESKeyWrappedSize(unwrappedSize: 16)
        
        XCTAssertEqual(wrappedKeySize, 24)
    }

    func testWrappedKeySize192Bit() {
        let wrappedKeySize = AESKeyWrappedSize(unwrappedSize: 24)

        XCTAssertEqual(wrappedKeySize, 32)
    }

    func testWrappedKeySize256Bit() {
        let wrappedKeySize = AESKeyWrappedSize(unwrappedSize: 32)

        XCTAssertEqual(wrappedKeySize, 40)
    }
    
    func testUnwrappedKeySize128Bit() {
        let wrappedKeySize = AESKeyUnwrappedSize(wrappedSize: 24)
        
        XCTAssertEqual(wrappedKeySize, 16)
    }

    func testUnwrappedKeySize192Bit() {
        let wrappedKeySize = AESKeyUnwrappedSize(wrappedSize: 32)

        XCTAssertEqual(wrappedKeySize, 24)
    }

    func testUnwrappedKeySize256Bit() {
        let wrappedKeySize = AESKeyUnwrappedSize(wrappedSize: 40)

        XCTAssertEqual(wrappedKeySize, 32)
    }

    func testKeyWrapKey128BitKeyEncryptionKey128Bit() throws {
        let wrappedKey = try AESKeyWrap(key128Bit, using: keyEncryptionKey128Bit)

        XCTAssertEqual(wrappedKey, wrappedKey128BitKeyEncryptionKey128Bit)
    }

    func testKeyWrapKey128BitKeyEncryptionKey192Bit() throws {
        let wrappedKey = try AESKeyWrap(key128Bit, using: keyEncryptionKey192Bit)

        XCTAssertEqual(wrappedKey, wrappedKey128BitKeyEncryptionKey192Bit)
    }

    func testKeyWrapKey128BitKeyEncryptionKey256Bit() throws {
        let wrappedKey = try AESKeyWrap(key128Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(wrappedKey, wrappedKey128BitKeyEncryptionKey256Bit)
    }

    func testKeyWrapKey192BitKeyEncryptionKey192Bit() throws {
        let wrappedKey = try AESKeyWrap(key192Bit, using: keyEncryptionKey192Bit)

        XCTAssertEqual(wrappedKey, wrappedKey192BitKeyEncryptionKey192Bit)
    }

    func testKeyWrapKey192BitKeyEncryptionKey256Bit() throws {
        let wrappedKey = try AESKeyWrap(key192Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(wrappedKey, wrappedKey192BitKeyEncryptionKey256Bit)
    }

    func testKeyWrapKey256BitKeyEncryptionKey256Bit() throws {
        let wrappedKey = try AESKeyWrap(key256Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(wrappedKey, wrappedKey256BitKeyEncryptionKey256Bit)
    }

    func testKeyUnwrapKey128BitKeyEncryptionKey128Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey128BitKeyEncryptionKey128Bit, using: keyEncryptionKey128Bit)

        XCTAssertEqual(key, key128Bit)
    }

    func testKeyUnwrapKey128BitKeyEncryptionKey192Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey128BitKeyEncryptionKey192Bit, using: keyEncryptionKey192Bit)

        XCTAssertEqual(key, key128Bit)
    }

    func testKeyUnwrapKey128BitKeyEncryptionKey256Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey128BitKeyEncryptionKey256Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(key, key128Bit)
    }

    func testKeyUnwrapKey192BitKeyEncryptionKey192Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey192BitKeyEncryptionKey192Bit, using: keyEncryptionKey192Bit)

        XCTAssertEqual(key, key192Bit)
    }

    func testKeyUnwrapKey192BitKeyEncryptionKey256Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey192BitKeyEncryptionKey256Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(key, key192Bit)
    }

    func testKeyUnwrapKey256BitKeyEncryptionKey256Bit() throws {
        let key = try AESKeyUnwrap(wrappedKey256BitKeyEncryptionKey256Bit, using: keyEncryptionKey256Bit)

        XCTAssertEqual(key, key256Bit)
    }
    
}
