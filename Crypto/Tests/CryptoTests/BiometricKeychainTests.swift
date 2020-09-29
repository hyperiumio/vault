import Combine
import LocalAuthentication
import XCTest
@testable import Crypto

class BiometricKeychainTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        subscriptions.removeAll()
        KeychainWrite = { _, _ in fatalError() }
        KeychainLoad = { _, _ in fatalError() }
        KeychainDelete = { _ in fatalError() }
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        KeychainWrite = SecItemAdd
        KeychainLoad = SecItemCopyMatching
        KeychainDelete = SecItemDelete
        
        super.tearDown()
    }
    
    func testStorePasswordSuccess() {
        KeychainDelete = { _ in errSecSuccess }
        KeychainWrite = { _, _ in errSecSuccess }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        Keychain.shared.storePassword("foo", identifier: "bar")
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
    
    func testStorePasswordDeleteDidFail() {
        KeychainDelete = { query in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.storePassword("", identifier: "")
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
        KeychainDelete = { _ in errSecSuccess }
        KeychainWrite = { attribtes, result in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.storePassword("", identifier: "")
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
        
        KeychainLoad = { query, result in
            result?.pointee = Data(expectedPassword.utf8) as CFData
            return errSecSuccess
        }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        Keychain.shared.loadPassword(identifier: "")
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
    
    func testLoadPasswordLoadDidFail() {
        KeychainLoad = { query, result in
            return -1
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.loadPassword(identifier: "")
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
        KeychainLoad = { query, result in
            result?.pointee = "" as CFString
            return errSecSuccess
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.loadPassword(identifier: "")
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
        KeychainLoad = { query, result in
            result?.pointee = Data("FF") as CFData
            return errSecSuccess
        }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.loadPassword(identifier: "")
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
        KeychainDelete = { _ in errSecSuccess }
        
        let successExpectation = XCTestExpectation()
        let expectations = [successExpectation]
        
        Keychain.shared.deletePassword(identifier: "")
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
    
    func testDeletePasswordDeleteDidFail() {
        KeychainDelete = { query in -1 }
        
        let failureExpectation = XCTestExpectation()
        let expectations = [failureExpectation]
        
        Keychain.shared.deletePassword(identifier: "")
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
