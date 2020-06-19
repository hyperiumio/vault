import Combine
import Foundation

public class PreferencesManager {
    
    public var didChange: AnyPublisher<Preferences, Never> {
        return didChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var preferences: Preferences { didChangeSubject.value }
    
    private let store: PreferencesStore
    private let didChangeSubject: CurrentValueSubject<Preferences, Never>
    
    private init() {
        let store = PreferencesStore(userDefaults: .standard)
        let preferences = Preferences(from: store)
        
        self.store = store
        self.didChangeSubject = CurrentValueSubject<Preferences, Never>(preferences)
    }
    
    public func set(isBiometricUnlockEnabled: Bool) {
        store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        didChangeSubject.value = Preferences(from: store)
    }
    
    public func set(activeVaultIdentifier: UUID) {
        store.activeVaultIdentifier = activeVaultIdentifier
        didChangeSubject.value = Preferences(from: store)
    }
    
}

extension PreferencesManager {
    
    public static let shared = PreferencesManager()
    
}
