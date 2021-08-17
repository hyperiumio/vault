import LocalAuthentication
import XCTest
@testable import Crypto
/*
class KeychainAttributeBuilderTests: XCTestCase {
    
    func testBuildAddAttributes() {
        let accessControlCreateCalled = XCTestExpectation()
        
        let data = [
            0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
        ] as Data
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = KeychainAttributeBuilder.Configuration(accessControlCreate: accessControlCreate)
        let builder = KeychainAttributeBuilder(accessGroup: "foo", configuration: configuration)
        let attributes = builder.buildAddAttributes(key: "bar", data: data, context: context) as? [CFString: AnyObject]
        let secClass = attributes?[kSecClass] as? String
        let secUseDataProtectionKeychain = attributes?[kSecUseDataProtectionKeychain] as? Bool
        let secAttrAccount = attributes?[kSecAttrAccount] as? String
        let secUseAuthenticationContext = attributes?[kSecUseAuthenticationContext]
        let secAttrAccessGroup = attributes?[kSecAttrAccessGroup] as? String
        let secValueData = attributes?[kSecValueData] as? Data
        
        XCTWaiter().wait(for: [accessControlCreateCalled], timeout: .infinity)
        
        XCTAssertEqual(secClass, kSecClassGenericPassword as String)
        XCTAssertEqual(secUseDataProtectionKeychain, true)
        XCTAssertEqual(secAttrAccount, "bar")
        XCTAssertIdentical(secUseAuthenticationContext, context)
        XCTAssertEqual(secAttrAccessGroup, "foo")
        XCTAssertEqual(secValueData, data)
        
        func accessControlCreate(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
            defer {
                accessControlCreateCalled.fulfill()
            }
            
            XCTAssertNil(allocator)
            XCTAssertEqual(protection as? String, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
            XCTAssertEqual(flags, .biometryCurrentSet)
            XCTAssertNil(error)
            
            return SecAccessControlCreateWithFlags(allocator, protection, flags, error)
        }
    }
    
    func testBuildDeleteAttributes() {
        let builder = KeychainAttributeBuilder(accessGroup: "foo")
        let attributes = builder.buildDeleteAttributes(key: "bar") as? [CFString: AnyObject]
        let secClass = attributes?[kSecClass] as? String
        let secUseDataProtectionKeychain = attributes?[kSecUseDataProtectionKeychain] as? Bool
        let secAttrAccount = attributes?[kSecAttrAccount] as? String
        let secAttrAccessGroup = attributes?[kSecAttrAccessGroup] as? String
        
        XCTAssertEqual(secClass, kSecClassGenericPassword as String)
        XCTAssertEqual(secUseDataProtectionKeychain, true)
        XCTAssertEqual(secAttrAccount, "bar")
        XCTAssertEqual(secAttrAccessGroup, "foo")
    }
    
    func testBuildLoadAttributes() {
        let builder = KeychainAttributeBuilder(accessGroup: "foo")
        let attributes = builder.buildLoadAttributes(key: "bar") as? [CFString: AnyObject]
        let secClass = attributes?[kSecClass] as? String
        let secUseDataProtectionKeychain = attributes?[kSecUseDataProtectionKeychain] as? Bool
        let secAttrAccount = attributes?[kSecAttrAccount] as? String
        let secAttrAccessGroup = attributes?[kSecAttrAccessGroup] as? String
        let secReturnData = attributes?[kSecReturnData] as? Bool
        
        XCTAssertEqual(secClass, kSecClassGenericPassword as String)
        XCTAssertEqual(secUseDataProtectionKeychain, true)
        XCTAssertEqual(secAttrAccount, "bar")
        XCTAssertEqual(secAttrAccessGroup, "foo")
        XCTAssertEqual(secReturnData, true)
    }
    
}
*/
