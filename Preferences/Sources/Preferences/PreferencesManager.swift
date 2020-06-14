import Combine
import Foundation

public class PreferencesManager {
    
    public var didChange: AnyPublisher<Preferences, Never> {
        return didChangeSubject
            .compactMap { preferences in preferences }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private let store: PreferencesStore
    private let workQueue = DispatchQueue(label: "PreferencesManagerWorkQueue")
    private let didChangeSubject = CurrentValueSubject<Preferences?, Never>(nil)
    
    public init(userDefaults: UserDefaults) {
        self.store = PreferencesStore(userDefaults: userDefaults)
        
        workQueue.async { [store, didChangeSubject] in
            let preferences = Preferences(from: store)
            didChangeSubject.send(preferences)
        }
    }
    
    public func set(isBiometricUnlockEnabled: Bool) {
        workQueue.async { [store, didChangeSubject] in
            store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
            let preferences = Preferences(from: store)
            didChangeSubject.send(preferences)
        }
    }
    
}
