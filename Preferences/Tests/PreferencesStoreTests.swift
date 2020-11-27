import XCTest
@testable import Preferences

final class PreferencesStoreTests: XCTestCase {
    
    func testInit() {
        let registrationDictionary = ["BiometricUnlockEnabled": false]
        let expectation = [
            UserDefaultsMock.Event.register(defaults: registrationDictionary)
        ]
        let mock = UserDefaultsMock(expectation: expectation)
        
        let _ = PreferencesStore(userDefaults: mock)
        
        mock.validate()
    }
    
    func testGetBiometricUnlockEnabled() {
        let expectation = [
            UserDefaultsMock.Event.any,
            UserDefaultsMock.Event.bool(forKey: "BiometricUnlockEnabled")
        ]
        let output = UserDefaultsMock.Output(boolForKey: true)
        let mock = UserDefaultsMock(expectation: expectation, output: output)
        
        let value = PreferencesStore(userDefaults: mock).isBiometricUnlockEnabled
        
        XCTAssertEqual(value, true)
        mock.validate()
    }
    
    func testSetBiometricUnlockEnabled() {
        let expectation = [
            UserDefaultsMock.Event.any,
            UserDefaultsMock.Event.setBool(value: true, forKey: "BiometricUnlockEnabled")
        ]
        let mock = UserDefaultsMock(expectation: expectation)
        
        PreferencesStore(userDefaults: mock).isBiometricUnlockEnabled = true
        
        mock.validate()
    }
    
    func testGetActiveVaultIdentifierValue() {
        let expectation = [
            UserDefaultsMock.Event.any,
            UserDefaultsMock.Event.string(forKey: "ActiveVaultIdentifier")
        ]
        let output = UserDefaultsMock.Output(stringForKey: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        let mock = UserDefaultsMock(expectation: expectation, output: output)
        
        let value = PreferencesStore(userDefaults: mock).activeVaultIdentifier
        let expectedValue = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        
        XCTAssertEqual(value, expectedValue)
        mock.validate()
    }
    
    func testGetActiveVaultIdentifierNil() {
        let expectation = [
            UserDefaultsMock.Event.any,
            UserDefaultsMock.Event.string(forKey: "ActiveVaultIdentifier")
        ]
        let output = UserDefaultsMock.Output(stringForKey: nil)
        let mock = UserDefaultsMock(expectation: expectation, output: output)
        
        let value = PreferencesStore(userDefaults: mock).activeVaultIdentifier
        
        XCTAssertNil(value)
        mock.validate()
    }
    
    func testSetActiveVaultIdentifier() {
        let expectation = [
            UserDefaultsMock.Event.any,
            UserDefaultsMock.Event.setString(value: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F", forKey: "ActiveVaultIdentifier")
        ]
        let mock = UserDefaultsMock(expectation: expectation)
        
        PreferencesStore(userDefaults: mock).activeVaultIdentifier = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        
        mock.validate()
    }
    
}

private class UserDefaultsMock: UserDefaultsRepresentable {
    
    private let expectation: [Event]
    private let output: Output
    private var recorded = [Event]()
    
    init(expectation: [Event], output: Output = Output()) {
        self.expectation = expectation
        self.output = output
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        let event = Event.setBool(value: value, forKey: defaultName)
        recorded.append(event)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        let event = Event.setString(value: value as! String, forKey: defaultName)
        recorded.append(event)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        let event = Event.bool(forKey: defaultName)
        recorded.append(event)
        return output.boolForKey
    }
    
    func string(forKey defaultName: String) -> String? {
        let event = Event.string(forKey: defaultName)
        recorded.append(event)
        return output.stringForKey
    }
    
    func register(defaults registrationDictionary: [String : Any]) {
        let event = Event.register(defaults: registrationDictionary as! [String: Bool])
        recorded.append(event)
    }
    
    func validate() {
        XCTAssertEqual(recorded.count, expectation.count)
        
        for (recorded, expected) in zip(recorded, expectation) {
            if expected == .any { continue }
            
            XCTAssertEqual(recorded, expected)
        }
    }
    
}

private extension UserDefaultsMock {
    
    enum Event: Equatable {
        
        case any
        case setBool(value: Bool, forKey: String)
        case setString(value: String, forKey: String)
        case bool(forKey: String)
        case string(forKey: String)
        case register(defaults: [String : Bool])
        
    }
    
    struct Output {
        
        let boolForKey: Bool
        let stringForKey: String?
        
        init(boolForKey: Bool = false, stringForKey: String? = nil) {
            self.boolForKey = boolForKey
            self.stringForKey = stringForKey
        }
        
    }
    
}
