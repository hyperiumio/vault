import Combine
import Foundation

public class PreferencesManager {
    
    public let didChange: CurrentValueSubject<Preferences, Never>
    
    private let store: PreferencesStore
    
    public init(userDefaults: UserDefaults) {
        let store = PreferencesStore(userDefaults: userDefaults)
        let preferences = Preferences(from: store)
        
        self.didChange = CurrentValueSubject(preferences)
        self.store = store
    }
    
    public func set(isBiometricUnlockEnabled: Bool) {
        store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        didChange.value = Preferences(from: store)
    }
    
}
