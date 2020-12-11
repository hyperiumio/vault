import Combine
import LocalAuthentication
import XCTest
@testable import Crypto

class KeychainTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    func testInitTouchID() {
        let contextStub = KeychainContextStub(biometryType: .touchID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .enrolled(.touchID))
    }
    
    func testInitFaceID() {
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .enrolled(.faceID))
    }
    
    func testInitNotEnrolled() {
        let contextStub = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false, canEvaluteError: LAError.biometryNotEnrolled)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .notEnrolled)
    }
    
    func testInitNotAvailable() {
        let contextStub = KeychainContextStub(biometryType: .none, canEvaluatePolicy: false)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
        let keychain = Keychain(accessGroup: "", configuration: configuration)
        
        XCTAssertEqual(keychain.availability, .notAvailable)
    }
    
    func testStoreSecretSuccess() {
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecNotAvailable } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecNotAvailable } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
    
    func testLoadSecretSuccess() {
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, result in
            result?.pointee = Data(0 ... UInt8.max) as CFData
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecUserCanceled } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, result in
            result?.pointee = "" as CFString
            return errSecSuccess
        } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecNotAvailable } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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

    func testDeleteSecretSuccess() {
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecSuccess } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
        let contextStub = KeychainContextStub(biometryType: .faceID, canEvaluatePolicy: true)
        let store = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load = { _, _ in errSecSuccess } as (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete = { _ in errSecNotAvailable } as (CFDictionary) -> OSStatus
        let configuration = Keychain.Configuration(context: contextStub, store: store, load: load, delete: delete)
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
    /*
    func testStorePasswordWriteArguments() {
        let expectedPassword = "foo"
        let expectedIdentifier = "bar"
        let expectedPasswordData = Data(expectedPassword.utf8)
        let expectedAccessControlTypeId = SecAccessControlGetTypeID()
        
        KeychainDelete = { _ in errSecSuccess }
        
        KeychainWrite = { attributes, result in
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

        let doneExpectation = XCTestExpectation()
        let expectations = [doneExpectation]
        
        Keychain.shared.storePassword(expectedPassword, identifier: expectedIdentifier)
            .sink(
                receiveCompletion: { completion in
                    doneExpectation.fulfill()
                },
                receiveValue: { _ in
                    doneExpectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    

    
    func testLoadPasswordLoadArguments() {
        let expectedIdentifier = "foo"
        
        KeychainLoad = { query, result in
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
        
        let doneExpectation = XCTestExpectation()
        let expectations = [doneExpectation]
        
        Keychain.shared.loadPassword(identifier: expectedIdentifier)
            .sink(
                receiveCompletion: { completion in
                    doneExpectation.fulfill()
                },
                receiveValue: { _ in
                    doneExpectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    

    
    func testDeletePasswordDeleteArguments() throws {
        let expectedIdentifier = "foo"
        
        KeychainDelete = { query in
            let query = query as? [CFString: AnyObject]
            let secClass = query?[kSecClass] as? String
            let secAttrService = query?[kSecAttrService] as? String
            
            XCTAssertEqual(secClass, kSecClassGenericPassword as String)
            XCTAssertEqual(secAttrService, expectedIdentifier)
            
            return errSecSuccess
        }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        Keychain.shared.deletePassword(identifier: expectedIdentifier)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail()
                    }
                },
                receiveValue: { password in
                    successExpectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
 */
    
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

private struct KeychainContextStub: KeychainContext {
    
    let biometryType: LABiometryType
    let canEvaluatePolicy: Bool
    let canEvaluteError: LAError?
    
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
