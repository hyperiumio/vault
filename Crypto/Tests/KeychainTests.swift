import LocalAuthentication
import XCTest
@testable import Crypto

class KeychainTests: XCTestCase {
    
    func testStoreSecretSuccess() {
        asyncTest {
            let deleteCalled = XCTestExpectation()
            let storeCalled = XCTestExpectation()
            let accessGroup = "foo"
            let key = "bar"
            let secret = Data(0...UInt8.max)
            let context = KeychainContextStub(biometryType: .none, canEvaluatePolicyResult: false)
            let configuration = Keychain.Configuration(context: context, accessControlCreate: accessControlCreate, store: store, load: load, delete: delete)
            let keychain = Keychain(accessGroup: accessGroup, configuration: configuration)
            
            try await keychain.storeSecret(secret, forKey: key)
            
            let result = XCTWaiter.wait(for: [deleteCalled, storeCalled], timeout: .infinity, enforceOrder: true)
            XCTAssertEqual(result, .completed)
            
            func accessControlCreate(allocator: CFAllocator?, protection: CFTypeRef, flags: SecAccessControlCreateFlags, error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl? {
                SecAccessControlCreateWithFlags(allocator, protection, flags, error)
            }
            
            func store(attributes: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
                defer {
                    storeCalled.fulfill()
                }
                XCTAssertNil(result)
                return errSecSuccess
            }
            
            func load(query: CFDictionary, result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
                XCTFail()
                return errSecSuccess
            }
            
            func delete(query: CFDictionary) -> OSStatus {
                defer {
                    deleteCalled.fulfill()
                }
                let builder = KeychainAttributeBuilder(accessGroup: accessGroup)
                let expectedQuery = builder.buildDeleteAttributes(key: key)
                XCTAssertEqual(query, expectedQuery)
                return errSecSuccess
            }
        }
    }
    
     /*
    func testStoreSecretSuccess() {
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(store: store, delete: delete)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).storeSecret(Data(), forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: {
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testStoreSecretSuccessItemNotInKeychain() {
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecItemNotFound } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(store: store, delete: delete)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).storeSecret(Data(), forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: {
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testStoreSecretDeleteFailed() {
        let delete = { _ in errSecNotAvailable } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(delete: delete)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).storeSecret(Data(), forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.failed)
                completionExpectation.fulfill()
            } receiveValue: {}
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testStoreSecretStoreFailed() {
        let store = { _, _ in errSecNotAvailable } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(store: store, delete: delete)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).storeSecret(Data(), forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.failed)
                completionExpectation.fulfill()
            } receiveValue: {}
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadSecretCallArguments() {
        let accessGroup = "foo"
        let key = "bar"
        
        let load = { query, result in
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secUseDataProtectionKeychain = query?[kSecUseDataProtectionKeychain] as? Bool
            let secAttrAccount = query?[kSecAttrAccount] as? String
            let secAttrAccessGroup = query?[kSecAttrAccessGroup] as? String
            let secReturnData = query?[kSecReturnData] as? Bool
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secUseDataProtectionKeychain, true)
            XCTAssertEqual(secAttrAccount, key)
            XCTAssertEqual(secAttrAccessGroup, accessGroup)
            XCTAssertEqual(secReturnData, true)
            XCTAssertNotNil(result)
            
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
 
        let configuration = Keychain.Configuration.stub(load: load)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: accessGroup, configuration: configuration).loadSecret(forKey: key)
            .sink { completion in
                completionExpectation.fulfill()
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadSecretSuccess() {
        let load = { _, result in
            result?.pointee = Data(0 ... UInt8.max) as CFData
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let configuration = Keychain.Configuration.stub(load: load)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).loadSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: { secret in
                XCTAssertEqual(secret, Data(0 ... UInt8.max))
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadSecretCanceled() {
        let load = { _, _ in errSecUserCanceled } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let configuration = Keychain.Configuration.stub(load: load)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).loadSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: { secret in
                XCTAssertNil(secret)
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadSecretInvalidResultType() {
        let load = { _, result in
            result?.pointee = "" as CFString
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let configuration = Keychain.Configuration.stub(load: load)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).loadSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.failed)
                completionExpectation.fulfill()
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadSecretFailure() {
        let load = { _, _ in errSecNotAvailable } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let configuration = Keychain.Configuration.stub(load: load)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).loadSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.failed)
                completionExpectation.fulfill()
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testDeleteSecretCallArguents() {
        let accessGroup = "foo"
        let key = "bar"
        
        let delete = { query in
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secUseDataProtectionKeychain = query?[kSecUseDataProtectionKeychain] as? Bool
            let secAttrAccount = query?[kSecAttrAccount] as? String
            let secAttrAccessGroup = query?[kSecAttrAccessGroup] as? String
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secUseDataProtectionKeychain, true)
            XCTAssertEqual(secAttrAccount, key)
            XCTAssertEqual(secAttrAccessGroup, accessGroup)
            
            return errSecSuccess
        } as (CFDictionary) -> OSStatus
 
        let configuration = Keychain.Configuration.stub(delete: delete)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: accessGroup, configuration: configuration).deleteSecret(forKey: key)
            .sink { completion in
                completionExpectation.fulfill()
            } receiveValue: {}
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }

    func testDeleteSecretSuccess() {
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(delete: delete)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).deleteSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: {
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testDeleteSecretItemNotFound() {
        let delete = { _ in errSecItemNotFound } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(delete: delete)
        let valueExpectation = XCTestExpectation()
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).deleteSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.finished)
                completionExpectation.fulfill()
            } receiveValue: {
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [valueExpectation, completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testDeleteSecretFailure() {
        let delete = { _ in errSecNotAvailable } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration.stub(delete: delete)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: "", configuration: configuration).deleteSecret(forKey: "")
            .sink { completion in
                XCTAssertTrue(completion.failed)
                completionExpectation.fulfill()
            } receiveValue: {}
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testInvalidateAvailability() {
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false)
        let configuration = Keychain.Configuration.stub(context: context)
        let completionExpectation = XCTestExpectation()
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        keychain.availabilityDidChange
            .dropFirst()
            .sink { availablility in
                XCTAssertEqual(availablility, .enrolled(.faceID))
                completionExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        context.biometryType = .faceID
        context.canEvaluatePolicy = true
        keychain.invalidateAvailability()
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    */
    
}
