import Combine
import Foundation

public protocol PreferencesStore: class {
    
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
    
    public func set(activeVaultIdentifier: UUID) {
        store.activeVaultIdentifier = activeVaultIdentifier
        didChangeSubject.value = Value(from: store)
    }
    
}

extension Preferences {
    
    public struct Value: Equatable {
        
        public let isBiometricUnlockEnabled: Bool
        public let activeVaultIdentifier: UUID?
        
        init(from store: PreferencesStore) {
            self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
            self.activeVaultIdentifier = store.activeVaultIdentifier
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
    
    var activeVaultIdentifier: UUID? {
        get {
            guard let vaultIdentifier = string(forKey: .activeVaultIdentifier) else {
                return nil
            }
            return UUID(uuidString: vaultIdentifier)
        }
        set(activeVaultIdentifier) {
            set(activeVaultIdentifier?.uuidString, forKey: .activeVaultIdentifier)
        }
    }
    
}

private extension String {
    
    static var biometricUnlockEnabledKey: Self { "BiometricUnlockEnabled" }
    static var activeVaultIdentifier: Self { "ActiveVaultIdentifier" }
    
}
