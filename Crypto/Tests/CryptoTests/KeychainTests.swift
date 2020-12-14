import Combine
import LocalAuthentication
import XCTest
@testable import Crypto

class KeychainTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    func testInitTouchID() {
        let context = KeychainContextStub(biometryType: .touchID, canEvaluatePolicy: true)
        let configuration = Keychain.Configuration.stub(context: context)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .enrolled(.touchID))
    }
    
    func testInitFaceID() {
        let context = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let configuration = Keychain.Configuration.stub(context: context)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .enrolled(.faceID))
    }
    
    func testInitNotEnrolled() {
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false, canEvaluteError: LAError.biometryNotEnrolled)
        let configuration = Keychain.Configuration.stub(context: context)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .notEnrolled)
    }
    
    func testInitNotAvailable() {
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false)
        let configuration = Keychain.Configuration.stub(context: context)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .notAvailable)
    }
    
    func testStoreSecretCallArguments() {
        let accessGroup = "foo"
        let key = "bar"
        let secret = Data(0 ... UInt8.max)
        let context = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false)
        
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
        
        let store = { attributes, result in
            let attributes = attributes as? [CFString: AnyObject]
            let secClass = attributes?[kSecClass] as? String
            let secUseDataProtectionKeychain = attributes?[kSecUseDataProtectionKeychain] as? Bool
            let secAttrAccessControl = attributes?[kSecAttrAccessControl]
            let secAttrAccount = attributes?[kSecAttrAccount] as? String
            let secUseAuthenticationContext = attributes?[kSecUseAuthenticationContext] as? KeychainContextStub
            let secAttrAccessGroup = attributes?[kSecAttrAccessGroup] as? String
            let secValueData = attributes?[kSecValueData] as? Data
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secUseDataProtectionKeychain, true)
            XCTAssertEqual(CFGetTypeID(secAttrAccessControl), SecAccessControlGetTypeID())
            XCTAssertEqual(secAttrAccount, key)
            XCTAssertTrue(secUseAuthenticationContext === context)
            XCTAssertEqual(secAttrAccessGroup, accessGroup)
            XCTAssertEqual(secValueData, secret)
            XCTAssertNil(result)
            
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
 
        let configuration = Keychain.Configuration.stub(context: context, store: store, delete: delete)
        let completionExpectation = XCTestExpectation()
        
        Keychain(accessGroup: accessGroup, configuration: configuration).storeSecret(secret, forKey: key)
            .sink { completion in
                completionExpectation.fulfill()
            } receiveValue: {}
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [completionExpectation], timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
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
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecNotAvailable } as (CFDictionary) -> OSStatus
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
    
}

private extension Keychain.Configuration {
    
    static func stub(context: KeychainContext = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false), store: @escaping (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = { _, _ in errSecSuccess }, load: @escaping (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = { _, _ in errSecSuccess }, delete: @escaping (CFDictionary) -> OSStatus = { _ in errSecSuccess }) -> Self {
        Self(context: context, store: store, load: load, delete: delete)
    }
    
}

private extension Subscribers.Completion {
    
    var finished: Bool {
        switch self {
        case .finished:
            return true
        case .failure:
            return false
        }
    }
    
    var failed: Bool {
        switch self {
        case .finished:
            return false
        case .failure:
            return true
        }
    }
    
}

private class KeychainContextStub: KeychainContext {
    
    var biometryType: LABiometryType
    var canEvaluatePolicy: Bool
    var canEvaluteError: LAError?
    
    var canEvaluatePolicyCallArgs = [(policy: LAPolicy, error: NSErrorPointer)]()
    
    init(biometryType: LABiometryType, canEvaluatePolicy: Bool, canEvaluteError: LAError.Code? = nil) {
        self.biometryType = biometryType
        self.canEvaluatePolicy = canEvaluatePolicy
        self.canEvaluteError = canEvaluteError.map { code in
            LAError(code)
        }
    }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        if let canEvaluteError = canEvaluteError {
            error?.pointee = NSError(domain: LAError.errorDomain, code: canEvaluteError.errorCode, userInfo: canEvaluteError.errorUserInfo)
        }
        return canEvaluatePolicy
    }
    
}
