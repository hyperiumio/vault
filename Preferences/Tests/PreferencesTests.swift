import Combine
import XCTest
@testable import Preferences

final class PreferencesTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        subscriptions.removeAll()
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func testInitEmptyStore() {
        let mock = PreferencesStoreMock()
        let preferences = Preferences(using: mock)
        
        XCTAssertEqual(preferences.value.isBiometricUnlockEnabled, false)
        XCTAssertNil(preferences.value.activeStoreID)
    }
    
    func testInitNonEmptyStore() {
        let expectedActiveVaultID = UUID()
        let storeMock = PreferencesStoreMock()
        storeMock.defaults = [
            "BiometricUnlockEnabled": true,
            "ActiveStoreID": expectedActiveVaultID
        ]
        let preferences = Preferences(using: storeMock)
        
        XCTAssertEqual(preferences.value.isBiometricUnlockEnabled, true)
        XCTAssertNil(preferences.value.activeStoreID)
    }
    
    func testSetBiometricUnlockEnabled() {
        let didChangeExpectation = XCTestExpectation()
        let storeMock = PreferencesStoreMock()
        let preferences = Preferences(using: storeMock)
        preferences.didChange
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.isBiometricUnlockEnabled, true)
                didChangeExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        preferences.set(isBiometricUnlockEnabled: true)
        
        let waitResult = XCTWaiter.wait(for: [didChangeExpectation], timeout: .infinity)
        XCTAssertEqual(waitResult, .completed)
        XCTAssertEqual(storeMock.defaults["BiometricUnlockEnabled"] as? Bool, true)
    }

    func testActiveVaultIdentifier() {
        let didChangeExpectation = XCTestExpectation()
        let expectedActiveStoreID = UUID()
        let storeMock = PreferencesStoreMock()
        let preferences = Preferences(using: storeMock)
        preferences.didChange
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.activeStoreID, expectedActiveStoreID)
                didChangeExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        preferences.set(activeStoreID: expectedActiveStoreID)
        
        let waitResult = XCTWaiter.wait(for: [didChangeExpectation], timeout: .infinity)
        XCTAssertEqual(waitResult, .completed)
        XCTAssertEqual(storeMock.defaults["ActiveStoreID"] as? String, expectedActiveStoreID.uuidString)
    }
    
}

private class PreferencesStoreMock: PreferencesStore {
    
    var registeredDefaults = [String: Any]()
    var defaults = [String: Any]()
    
    func set(_ value: Bool, forKey defaultName: String) {
        defaults[defaultName] = value
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        defaults[defaultName] = value
    }
    
    func bool(forKey defaultName: String) -> Bool {
        (defaults[defaultName] ?? registeredDefaults[defaultName]) as! Bool
    }
    
    func string(forKey defaultName: String) -> String? {
        (defaults[defaultName] ?? registeredDefaults[defaultName]) as? String? ?? nil
    }
    
    func register(defaults registrationDictionary: [String : Any]) {
        registeredDefaults = registrationDictionary
    }
    
}
