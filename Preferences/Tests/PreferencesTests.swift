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
    
    func testInitialPreferencesValue() {
        let expectedActiveVaultIdentifier = UUID()
        let mock = PreferencesStoreMock()
        mock.isBiometricUnlockEnabled = true
        mock.activeVaultIdentifier = expectedActiveVaultIdentifier
        
        let preferences = Preferences(preferencesStore: mock)
        
        XCTAssertEqual(preferences.value.isBiometricUnlockEnabled, true)
        XCTAssertEqual(preferences.value.activeVaultIdentifier, expectedActiveVaultIdentifier)
    }
    
    func testSetBiometricUnlockEnabled() {
        let didChangeExpectation = XCTestExpectation()
        let expectations = [didChangeExpectation]
        
        let mock = PreferencesStoreMock()
        mock.isBiometricUnlockEnabled = false
        let preferences = Preferences(preferencesStore: mock)
        preferences.didChange
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.isBiometricUnlockEnabled, true)
                didChangeExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        preferences.set(isBiometricUnlockEnabled: true)
        
        let waitResult = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(waitResult, .completed)
        XCTAssertEqual(mock.isBiometricUnlockEnabled, true)
    }
    
    func testActiveVaultIdentifier() {
        let didChangeExpectation = XCTestExpectation()
        let expectations = [didChangeExpectation]
        
        let expectedActiveVaultIdentifier = UUID()
        let mock = PreferencesStoreMock()
        mock.activeVaultIdentifier = nil
        let preferences = Preferences(preferencesStore: mock)
        
        preferences.didChange
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.activeVaultIdentifier, expectedActiveVaultIdentifier)
                didChangeExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        preferences.set(activeVaultIdentifier: expectedActiveVaultIdentifier)
        
        let waitResult = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(waitResult, .completed)
        XCTAssertEqual(mock.activeVaultIdentifier, expectedActiveVaultIdentifier)
    }
    
}

private class PreferencesStoreMock: PreferencesStoreRepresentable {
    
    var isBiometricUnlockEnabled = false
    var activeVaultIdentifier = nil as UUID?
    
}
