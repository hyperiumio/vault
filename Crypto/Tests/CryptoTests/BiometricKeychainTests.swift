import LocalAuthentication
import XCTest
@testable import Crypto

class BiometricKeychainTests: XCTestCase {
    
    func testStorePasswordSuccess() throws {
        
        func write(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            return errSecSuccess
        }
        
        try BiometricKeychain(write: write, delete: delete).storePassword("foo", identifier: "bar")
    }
    
    func testStorePasswordAccessControlArguments() throws {
        
        func accessControl(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
            XCTAssertNil(allocator)
            XCTAssertEqual(protection as? String, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
            XCTAssertEqual(flags, .biometryCurrentSet)
            XCTAssertNil(error)
            
            return SecAccessControlCreateWithFlags(allocator, protection, flags, error)
        }
        
        func write(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            return errSecSuccess
        }
        
        try BiometricKeychain(accessControl: accessControl, write: write, delete: delete).storePassword("", identifier: "")
    }
    
    func testStorePasswordWriteArguments() throws {
        let expectedPassword = "foo"
        let expectedIdentifier = "bar"
        let expectedPasswordData = Data(expectedPassword.utf8)
        
        func write(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            let attributes = attributes as? [CFString: AnyObject]
            let secClass = attributes?[kSecClass] as? String
            let secAttrService = attributes?[kSecAttrService] as? String
            let secAttrAccessControl = attributes?[kSecAttrAccessControl]
            let secUseAuthenticationContext = attributes?[kSecUseAuthenticationContext]
            let secValueData = attributes?[kSecValueData] as? Data
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            XCTAssertEqual(CFGetTypeID(secAttrAccessControl), SecAccessControlGetTypeID())
            XCTAssert(secUseAuthenticationContext is LAContext)
            XCTAssertEqual(secValueData, expectedPasswordData)
            XCTAssertNil(result)
            
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            return errSecSuccess
        }
        
        try BiometricKeychain(write: write, delete: delete).storePassword(expectedPassword, identifier: expectedIdentifier)
    }
    
    func testStorePasswordDeleteDidFail() {
        
        func delete(query: CFDictionary) -> OSStatus {
            return -1
        }
        
        let keychain = BiometricKeychain(delete: delete)
        
        XCTAssertThrowsError(try keychain.storePassword("", identifier: ""))
    }
    
    func testStorePasswordWriteDidFail() {
        
        func delete(query: CFDictionary) -> OSStatus {
            return errSecSuccess
        }
        
        func write(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            return -1
        }
        
        let keychain = BiometricKeychain(write: write, delete: delete)
        
        XCTAssertThrowsError(try keychain.storePassword("", identifier: ""))
    }
    
    func testLoadPasswordSuccess() throws {
        let expectedPassword = "foo"
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            result?.pointee = Data(expectedPassword.utf8) as CFData
            return errSecSuccess
        }
        
        let password = try BiometricKeychain(load: load).loadPassword(identifier: "")
        
        XCTAssertEqual(password, expectedPassword)
    }
    
    func testLoadPasswordLoadArguments() throws {
        let expectedIdentifier = "foo"
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
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
        
        _ = try BiometricKeychain(load: load).loadPassword(identifier: expectedIdentifier)
    }
    
    func testLoadPasswordLoadDidFail() {
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            return -1
        }
        
        let keychain = BiometricKeychain(load: load)
        
        XCTAssertThrowsError(try keychain.loadPassword(identifier: ""))
    }
    
    func testLoadPasswordInvalidResultType() {
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            result?.pointee = "" as CFString
            return errSecSuccess
        }
        
        let keychain = BiometricKeychain(load: load)
        
        XCTAssertThrowsError(try keychain.loadPassword(identifier: ""))
    }
    
    func testLoadPasswordInvalidResultData() {
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            result?.pointee = Data("FF") as CFData
            return errSecSuccess
        }
        
        let keychain = BiometricKeychain(load: load)
        
        XCTAssertThrowsError(try keychain.loadPassword(identifier: ""))
    }
    
    func testDeletePasswordSuccess() throws {
        
        func delete(query: CFDictionary) -> OSStatus {
            return errSecSuccess
        }
        
        try BiometricKeychain(delete: delete).deletePassword(identifier: "")
    }
    
    func testDeletePasswordDeleteArguments() throws {
        let expectedIdentifier = "foo"
        
        func delete(query: CFDictionary) -> OSStatus {
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secAttrService = query?[kSecAttrService] as? String
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            
            return errSecSuccess
        }
        
        try BiometricKeychain(delete: delete).deletePassword(identifier: expectedIdentifier)
    }
    
    func testDeletePasswordDeleteDidFail() {
        func delete(query: CFDictionary) -> OSStatus {
            return -1
        }
        
        let keychain = BiometricKeychain(delete: delete)
        XCTAssertThrowsError(try keychain.deletePassword(identifier: ""))
    }
    
}

