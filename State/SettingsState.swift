import Combine
import Crypto
import Foundation
import Preferences
import Model

#warning("Todo")
@MainActor
protocol SettingsStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChangeMasterPasswordState: ChangeMasterPasswordStateRepresentable
    
    var keychainAvailability: Keychain.Availability { get }
    var isBiometricUnlockEnabled: Bool { get set }
    var changeMasterPasswordState: ChangeMasterPasswordState { get }
    
}

@MainActor
protocol SettingsStateDependency {
     
    associatedtype ChangeMasterPasswordState: ChangeMasterPasswordStateRepresentable
    
    func changeMasterPasswordState() -> ChangeMasterPasswordState
    
}

@MainActor
class SettingsState<Dependency: SettingsStateDependency>: SettingsStateRepresentable {
    
    typealias ChangeMasterPasswordState = Dependency.ChangeMasterPasswordState
    
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool = true
    
    let changeMasterPasswordState: ChangeMasterPasswordState
    
    private let errorSubject = PassthroughSubject<SettingStateError, Never>()
    private var isBiometricUnlockEnabledSubscription: AnyCancellable?
    
    init(store: Store, derivedKey: DerivedKey, preferences: Preferences, keychain: Keychain, dependency: Dependency) {
        fatalError()
    }
    
}

enum SettingStateError: Error {
    
    case keychainAccessDidFail
    
}


#if DEBUG
class SettingsStateStub: SettingsStateRepresentable {
    
    @Published var changeMasterPasswordState: ChangeMasterPasswordState
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool
    
    init(changeMasterPasswordState: ChangeMasterPasswordState, keychainAvailability: Keychain.Availability, isBiometricUnlockEnabled: Bool) {
        self.changeMasterPasswordState = changeMasterPasswordState
        self.keychainAvailability = keychainAvailability
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func setBiometricUnlock(isEnabled: Bool) {}
    
}
#endif
