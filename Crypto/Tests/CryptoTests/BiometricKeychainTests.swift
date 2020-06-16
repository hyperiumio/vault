import Combine
import LocalAuthentication
import XCTest
@testable import Crypto

class BiometricKeychainTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        subscriptions.removeAll()
        BiometricKeychainWrite = { _, _ in fatalError() }
        BiometricKeychainLoad = { _, _ in fatalError() }
        BiometricKeychainDelete = { _ in fatalError() }
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        BiometricKeychainWrite = SecItemAdd
        BiometricKeychainLoad = SecItemCopyMatching
        BiometricKeychainDelete = SecItemDelete
        
        super.tearDown()
    }
    
    func testStorePasswordSuccess() {
        BiometricKeychainDelete = { _ in errSecSuccess }
        BiometricKeychainWrite = { _, _ in errSecSuccess }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        BiometricKeychain.shared.storePassword("foo", identifier: "bar")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail()
                    }
                },
                receiveValue: { _ in
                    successExpectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testStorePasswordWriteArguments() {
        let expectedPassword = "foo"
        let expectedIdentifier = "bar"
        let expectedPasswordData = Data(expectedPassword.utf8)
        let expectedAccessControlTypeId = SecAccessControlGetTypeID()
        
        BiometricKeychainDelete = { _ in errSecSuccess }
        
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

        let doneExpectation = XCTestExpectation()
        let expectations = [doneExpectation]
        
        BiometricKeychain.shared.storePassword(expectedPassword, identifier: expectedIdentifier)
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
    
    func testStorePasswordDeleteDidFail() {
        BiometricKeychainDelete = { query in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.storePassword("", identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testStorePasswordWriteDidFail() {
        BiometricKeychainDelete = { _ in errSecSuccess }
        BiometricKeychainWrite = { attribtes, result in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.storePassword("", identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadPasswordSuccess() {
        let expectedPassword = "foo"
        
        BiometricKeychainLoad = { query, result in
            result?.pointee = Data(expectedPassword.utf8) as CFData
            return errSecSuccess
        }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        BiometricKeychain.shared.loadPassword(identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail()
                    }
                },
                receiveValue: { password in
                    successExpectation.fulfill()
                    XCTAssertEqual(password, expectedPassword)
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadPasswordLoadArguments() {
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
        
        let doneExpectation = XCTestExpectation()
        let expectations = [doneExpectation]
        
        BiometricKeychain.shared.loadPassword(identifier: expectedIdentifier)
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
    
    func testLoadPasswordLoadDidFail() {
        BiometricKeychainLoad = { query, result in
            return -1
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.loadPassword(identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { password in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadPasswordInvalidResultType() {
        BiometricKeychainLoad = { query, result in
            result?.pointee = "" as CFString
            return errSecSuccess
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.loadPassword(identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { password in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testLoadPasswordInvalidResultData() {
        BiometricKeychainLoad = { query, result in
            result?.pointee = Data("FF") as CFData
            return errSecSuccess
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.loadPassword(identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { password in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testDeletePasswordSuccess() {
        BiometricKeychainDelete = { _ in errSecSuccess }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        BiometricKeychain.shared.deletePassword(identifier: "")
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
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        BiometricKeychain.shared.deletePassword(identifier: expectedIdentifier)
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
    
    func testDeletePasswordDeleteDidFail() {
        BiometricKeychainDelete = { query in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        BiometricKeychain.shared.deletePassword(identifier: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        failureExpectation.fulfill()
                    }
                },
                receiveValue: { password in
                    XCTFail()
                }
            )
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
}
