import LocalAuthentication
import XCTest
@testable import Crypto

class BiometricKeychainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        BiometricKeychainWrite = { _, _ in fatalError() }
        BiometricKeychainLoad = { _, _ in fatalError() }
        BiometricKeychainDelete = { _ in fatalError() }
    }
    
    override func tearDown() {
        BiometricKeychainWrite = SecItemAdd
        BiometricKeychainLoad = SecItemCopyMatching
        BiometricKeychainDelete = SecItemDelete
        
        super.tearDown()
    }
    
    func testStorePasswordSuccess() throws {
        BiometricKeychainWrite = { _, _ in errSecSuccess }
        BiometricKeychainDelete = { _ in errSecSuccess }
        
        try BiometricKeychainStorePassword("foo", identifier: "bar")
    }
    
    func testStorePasswordWriteArguments() throws {
        let expectedPassword = "foo"
        let expectedIdentifier = "bar"
        let expectedPasswordData = Data(expectedPassword.utf8)
        let expectedAccessControlTypeId = SecAccessControlGetTypeID()
        
        BiometricKeychainWrite = { attributes, result in
            let attributes = attributes as? [CFString: AnyObject]
            let secClass = attributes?[kSecClass] as? String
            let secAttrService = attributes?[kSecAttrService] as? String
            let secAttrAccessControl = attributes?[kSecAttrAccessControl]
            let secUseAuthenticationContext = attributes?[kSecUseAuthenticationContext]
            let secValueData = attributes?[kSecValueData] as? Data
            let accessControlTypeId = CFGetTypeID(secAttrAccessControl)
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            XCTAssertEqual(accessControlTypeId, expectedAccessControlTypeId)
            XCTAssert(secUseAuthenticationContext is LAContext)
            XCTAssertEqual(secValueData, expectedPasswordData)
            XCTAssertNil(result)
            
            return errSecSuccess
        }
        
        BiometricKeychainDelete = { _ in errSecSuccess }
        
        try BiometricKeychainStorePassword(expectedPassword, identifier: expectedIdentifier)
    }
    
    func testStorePasswordDeleteDidFail() {
        BiometricKeychainDelete = { query in -1 }
        
        XCTAssertThrowsError(try BiometricKeychainStorePassword("", identifier: ""))
    }
    
    func testStorePasswordWriteDidFail() {
        BiometricKeychainWrite = { attribtes, result in -1 }
        BiometricKeychainDelete = { _ in errSecSuccess }
        
        XCTAssertThrowsError(try BiometricKeychainStorePassword("", identifier: ""))
    }
    
    func testLoadPasswordSuccess() throws {
        let expectedPassword = "foo"
        
        BiometricKeychainLoad = { query, result in
            result?.pointee = Data(expectedPassword.utf8) as CFData
            return errSecSuccess
        }
        
        let password = try BiometricKeychainLoadPassword(identifier: "")
        
        XCTAssertEqual(password, expectedPassword)
    }
    
    func testLoadPasswordLoadArguments() throws {
        let expectedIdentifier = "foo"
        
        BiometricKeychainLoad = { query, result in
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secAttrService = query?[kSecAttrService] as? String
            let secReturnData = query?[kSecReturnData] as? Bool
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            XCTAssertEqual(secReturnData, true)
            XCTAssertNotNil(result)
            
            result?.pointee = Data() as CFData
            return errSecSuccess
        }
        
        _ = try BiometricKeychainLoadPassword(identifier: expectedIdentifier)
    }
    
    func testLoadPasswordLoadDidFail() {
        BiometricKeychainLoad = { query, result in
            return -1
        }
        
        XCTAssertThrowsError(try BiometricKeychainLoadPassword(identifier: ""))
    }
    
    func testLoadPasswordInvalidResultType() {
        BiometricKeychainLoad = { query, result in
            result?.pointee = "" as CFString
            return errSecSuccess
        }
        
        XCTAssertThrowsError(try BiometricKeychainLoadPassword(identifier: ""))
    }
    
    func testLoadPasswordInvalidResultData() {
        BiometricKeychainLoad = { query, result in
            result?.pointee = Data("FF") as CFData
            return errSecSuccess
        }
        
        XCTAssertThrowsError(try BiometricKeychainLoadPassword(identifier: ""))
    }
    
    func testDeletePasswordSuccess() throws {
        BiometricKeychainDelete = { _ in errSecSuccess }
        
        try BiometricKeychainDeletePassword(identifier: "")
    }
    
    func testDeletePasswordDeleteArguments() throws {
        let expectedIdentifier = "foo"
        
        BiometricKeychainDelete = { query in
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secAttrService = query?[kSecAttrService] as? String
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            
            return errSecSuccess
        }
        
        try BiometricKeychainDeletePassword(identifier: expectedIdentifier)
    }
    
    func testDeletePasswordDeleteDidFail() {
        BiometricKeychainDelete = { query in -1 }
        
        XCTAssertThrowsError(try BiometricKeychainDeletePassword(identifier: ""))
    }
    
}

