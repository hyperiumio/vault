import LocalAuthentication
import XCTest
@testable import Crypto

class KeychainTests: XCTestCase {
    
    func testInitAccessGroupConfiguration() {
        let accessControlCreateCalled = XCTestExpectation()
        let storeCalled = XCTestExpectation()
        let loadCalled = XCTestExpectation()
        let deleteCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .touchID, canEvaluatePolicyResult: true)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreate, store: store, load: load, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        let canEvaluatePolicyResult = keychain.configuration.context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        _ = keychain.configuration.accessControlCreate(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil)
        _ = keychain.configuration.store([:] as CFDictionary, nil)
        _ = keychain.configuration.load([:] as CFDictionary, nil)
        _ = keychain.configuration.delete([:] as CFDictionary)
        
        let result = XCTWaiter.wait(for: [accessControlCreateCalled, storeCalled, loadCalled, deleteCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        XCTAssertEqual(keychain.configuration.context.biometryType, .touchID)
        XCTAssertEqual(canEvaluatePolicyResult, true)
        XCTAssertEqual(keychain.attributeBuilder.accessGroup, "foo")
        
        func accessControlCreate(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
            defer {
                accessControlCreateCalled.fulfill()
            }
            return SecAccessControlCreateWithFlags(allocator, protection, flags, error)
        }
        
        func store(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                storeCalled.fulfill()
            }
            return errSecSuccess
        }
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                loadCalled.fulfill()
            }
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            return errSecSuccess
        }
    }
    
    func testStoreSecretSuccess() async throws {
        let accessControlCreateCalled = XCTestExpectation()
        let deleteCalled = XCTestExpectation()
        let storeCalled = XCTestExpectation()
        let secret = Data(0...UInt8.max)
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreate, store: store, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        try await keychain.storeSecret(secret, forKey: "bar")
        
        let result = XCTWaiter.wait(for: [deleteCalled, storeCalled], timeout: .infinity, enforceOrder: true)
        XCTAssertEqual(result, .completed)
        
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
        
        func store(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                storeCalled.fulfill()
            }
            let expectedAttributes = KeychainAttributeBuilder(accessGroup: "foo").buildAddAttributes(key: "bar", data: secret, context: context)
            XCTAssertEqual(attributes, expectedAttributes)
            XCTAssertNil(result)
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            let expectedQuery = KeychainAttributeBuilder(accessGroup: "foo").buildDeleteAttributes(key: "bar")
            XCTAssertEqual(query, expectedQuery)
            return errSecSuccess
        }
    }
    
    func testStoreSecretSuccessItemNotInKeychain() async throws {
        let accessControlCreateCalled = XCTestExpectation()
        let deleteCalled = XCTestExpectation()
        let storeCalled = XCTestExpectation()
        let secret = Data(0...UInt8.max)
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreate, store: store, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        try await keychain.storeSecret(secret, forKey: "bar")
        
        let result = XCTWaiter.wait(for: [deleteCalled, storeCalled], timeout: .infinity, enforceOrder: true)
        XCTAssertEqual(result, .completed)
        
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
        
        func store(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                storeCalled.fulfill()
            }
            let expectedAttributes = KeychainAttributeBuilder(accessGroup: "foo").buildAddAttributes(key: "bar", data: secret, context: context)
            XCTAssertEqual(attributes, expectedAttributes)
            XCTAssertNil(result)
            return errSecSuccess
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            let expectedQuery = KeychainAttributeBuilder(accessGroup: "foo").buildDeleteAttributes(key: "bar")
            XCTAssertEqual(query, expectedQuery)
            return errSecItemNotFound
        }
    }
    
    func testStoreSecretDeleteFailure() async throws {
        let deleteCalled = XCTestExpectation()
        let secret = Data()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        #warning("Workaround")
        do {
            try await keychain.storeSecret(secret, forKey: "")
            XCTFail()
        } catch {
            
        }
        
        let result = XCTWaiter.wait(for: [deleteCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            return errSecInternalError
        }
    }
    
    func testStoreSecretStoreFailure() async throws {
        let accessControlCreateCalled = XCTestExpectation()
        let deleteCalled = XCTestExpectation()
        let storeCalled = XCTestExpectation()
        let secret = Data()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreate, store: store, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        #warning("Workaround")
        do {
            try await keychain.storeSecret(secret, forKey: "")
            XCTFail()
        } catch {
            
        }
        
        let result = XCTWaiter.wait(for: [deleteCalled, accessControlCreateCalled, storeCalled], timeout: .infinity, enforceOrder: true)
        XCTAssertEqual(result, .completed)
        
        func accessControlCreate(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
            defer {
                accessControlCreateCalled.fulfill()
            }
            return SecAccessControlCreateWithFlags(allocator, protection, flags, error)
        }
        
        func store(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                storeCalled.fulfill()
            }
            return errSecInternalError
        }
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            return errSecSuccess
        }
    }
    
    func testLoadSecretSuccess() async throws {
        let loadCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: load, delete: deleteFailure)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        let data = try await keychain.loadSecret(forKey: "bar")
        
        let result = XCTWaiter.wait(for: [loadCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        XCTAssertEqual(data, Data(0...UInt8.max))
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                loadCalled.fulfill()
            }
            let expectedQuery = KeychainAttributeBuilder(accessGroup: "foo").buildLoadAttributes(key: "bar")
            XCTAssertEqual(query, expectedQuery)
            result?.pointee = Data(0...UInt8.max) as CFData
            return errSecSuccess
        }
    }
    
    func testLoadSecretCanceled() async throws {
        let loadCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: load, delete: deleteFailure)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        let data = try await keychain.loadSecret(forKey: "bar")
        
        let result = XCTWaiter.wait(for: [loadCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        XCTAssertNil(data)
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                loadCalled.fulfill()
            }
            return errSecUserCanceled
        }
    }
    
    func testLoadSecretInvalidResultType() async throws {
        let loadCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: load, delete: deleteFailure)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await keychain.loadSecret(forKey: "bar")
            XCTFail()
        } catch {
            
        }
        
        let result = XCTWaiter.wait(for: [loadCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                loadCalled.fulfill()
            }
            result?.pointee = "" as CFString
            return errSecSuccess
        }
    }
    
    func testLoadSecretFailure() async throws {
        let loadCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: load, delete: deleteFailure)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await keychain.loadSecret(forKey: "bar")
            XCTFail()
        } catch {
            
        }
        
        let result = XCTWaiter.wait(for: [loadCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
            defer {
                loadCalled.fulfill()
            }
            return errSecInternalError
        }
    }

    func testDeleteSecretSuccess() async throws {
        let deleteCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        try await keychain.deleteSecret(forKey: "bar")
        
        let result = XCTWaiter.wait(for: [deleteCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            let expectedQuery = KeychainAttributeBuilder(accessGroup: "foo").buildDeleteAttributes(key: "bar")
            XCTAssertEqual(query, expectedQuery)
            return errSecSuccess
        }
    }
    
    func testDeleteSecretSuccessItemNotFound() async throws {
        let deleteCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        try await keychain.deleteSecret(forKey: "bar")
        
        let result = XCTWaiter.wait(for: [deleteCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            let expectedQuery = KeychainAttributeBuilder(accessGroup: "foo").buildDeleteAttributes(key: "bar")
            XCTAssertEqual(query, expectedQuery)
            return errSecItemNotFound
        }
    }
    
    func testDeleteSecretFailure() async throws {
        let deleteCalled = XCTestExpectation()
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
        let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreateFailure, store: storeFailure, load: loadFailure, delete: delete)
        let keychain = Keychain(accessGroup: "foo", configuration: configuration)
        
        #warning("Workaround")
        do {
            try await keychain.deleteSecret(forKey: "bar")
            XCTFail()
        } catch {
            
        }
        
        let result = XCTWaiter.wait(for: [deleteCalled], timeout: .infinity)
        XCTAssertEqual(result, .completed)
        
        func delete(query: CFDictionary) -> OSStatus {
            defer {
                deleteCalled.fulfill()
            }
            return errSecInternalError
        }
    }
    
}

func accessControlCreateFailure(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
    XCTFail()
    return nil
}

func storeFailure(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
    XCTFail()
    return errSecInternalError
}

func loadFailure(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
    XCTFail()
    return errSecInternalError
}

func deleteFailure(query: CFDictionary) -> OSStatus {
    XCTFail()
    return errSecInternalError
}
