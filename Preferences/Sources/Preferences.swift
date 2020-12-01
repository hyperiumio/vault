import Combine
import Foundation

public class Preferences {
    
    public var didChange: AnyPublisher<Value, Never> {
        didChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var value: Value { didChangeSubject.value }
    
    private let userDefaults: UserDefaults
    private let didChangeSubject: CurrentValueSubject<Value, Never>
    
    public init?(appGroup: String) {
        guard let userDefaults = UserDefaults(suiteName: appGroup) else {
            return nil
        }
        let defaults = [String.biometricUnlockEnabledKey: false]
        userDefaults.register(defaults: defaults)
        
        let preferences = Value(from: userDefaults)
        
        self.userDefaults = userDefaults
        self.didChangeSubject = CurrentValueSubject<Value, Never>(preferences)
    }
    
    public func set(isBiometricUnlockEnabled: Bool) {
        userDefaults.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        didChangeSubject.value = Value(from: userDefaults)
    }
    
    public func set(activeVaultIdentifier: UUID) {
        userDefaults.activeVaultIdentifier = activeVaultIdentifier
        didChangeSubject.value = Value(from: userDefaults)
    }
    
}

extension Preferences {
    
    public struct Value: Equatable {
        
        public let isBiometricUnlockEnabled: Bool
        public let activeVaultIdentifier: UUID?
        
        init(from userDefaults: UserDefaults) {
            self.isBiometricUnlockEnabled = userDefaults.isBiometricUnlockEnabled
            self.activeVaultIdentifier = userDefaults.activeVaultIdentifier
        }
        
    }
    
}

private extension UserDefaults {
    
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
