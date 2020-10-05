import Combine
import Foundation

public class Preferences {
    
    public var didChange: AnyPublisher<Value, Never> {
        didChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var value: Value { didChangeSubject.value }
    
    private let store: PreferencesStoreRepresentable
    private let didChangeSubject: CurrentValueSubject<Value, Never>
    
    init(preferencesStore: PreferencesStoreRepresentable) {
        let preferences = Value(from: preferencesStore)
        
        self.store = preferencesStore
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
    
    public static let shared = Preferences(preferencesStore: PreferencesStore(userDefaults: UserDefaults.standard))
    
}

extension Preferences {
    
    public struct Value: Equatable {
        
        public let isBiometricUnlockEnabled: Bool
        public let activeVaultIdentifier: UUID?
        
        init(from store: PreferencesStoreRepresentable) {
            self.isBiometricUnlockEnabled = store.isBiometricUnlockEnabled
            self.activeVaultIdentifier = store.activeVaultIdentifier
        }
        
    }
    
}
