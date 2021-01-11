import Combine
import Foundation

public protocol PreferencesStore: AnyObject {
    
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func register(defaults registrationDictionary: [String : Any])
    
}

public class Preferences {
    
    public var didChange: AnyPublisher<Value, Never> {
        didChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var value: Value { didChangeSubject.value }
    
    private let store: PreferencesStore
    private let didChangeSubject: CurrentValueSubject<Value, Never>
    
    public init(using store: PreferencesStore) {
        let defaults = [String.biometricUnlockEnabledKey: false]
        store.register(defaults: defaults)
        
        let preferences = Value(from: store)
        
        self.store = store
        self.didChangeSubject = CurrentValueSubject<Value, Never>(preferences)
    }
    
    public func set(isBiometricUnlockEnabled: Bool) {
        store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        didChangeSubject.value = Value(from: store)
    }
    
    public func set(activeStoreID: UUID) {
        store.activeStoreID = activeStoreID
        didChangeSubject.value = Value(from: store)
    }
    
}

extension Preferences {
    
    public struct Value: Equatable {
        
        public let isBiometricUnlockEnabled: Bool
        public let activeStoreID: UUID?
        
        init(from store: PreferencesStore) {
            self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
            self.activeStoreID = store.activeStoreID
        }
        
    }
    
}

extension UserDefaults: PreferencesStore {}

private extension PreferencesStore {
    
    var isBiometricUnlockEnabled: Bool {
        get {
            bool(forKey: .biometricUnlockEnabledKey)
        }
        set(isBiometricUnlockEnabled) {
            set(isBiometricUnlockEnabled, forKey: .biometricUnlockEnabledKey)
        }
    }
    
    var activeStoreID: UUID? {
        get {
            guard let storeID = string(forKey: .activeStoreID) else {
                return nil
            }
            return UUID(uuidString: storeID)
        }
        set(storeID) {
            set(storeID?.uuidString, forKey: .activeStoreID)
        }
    }
    
}

private extension String {
    
    static var biometricUnlockEnabledKey: Self { "BiometricUnlockEnabled" }
    static var activeStoreID: Self { "ActiveStoreID" }
    
}
