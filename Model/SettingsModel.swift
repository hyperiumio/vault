import Combine
import Crypto
import Foundation
import Preferences
import Identifier
import Store

protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    var keychainAvailability: Keychain.Availability { get }
    var isBiometricUnlockEnabled: Bool { get set }
    var error: AnyPublisher<SettingModelError, Never> { get }
    var changeMasterPasswordModel: ChangeMasterPasswordModel { get }
    
}

protocol SettingsModelDependency {
     
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel
    
}

enum SettingModelError: Error {
    
    case keychainAccessDidFail
    
}

class SettingsModel<Dependency: SettingsModelDependency>: SettingsModelRepresentable {
    
    typealias ChangeMasterPasswordModel = Dependency.ChangeMasterPasswordModel
    
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool = true
    
    var error: AnyPublisher<SettingModelError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    let changeMasterPasswordModel: ChangeMasterPasswordModel
    
    private let vault: Vault
    private let preferences: Preferences
    private let keychain: Keychain
    private let dependency: Dependency
    private let errorSubject = PassthroughSubject<SettingModelError, Never>()
    private var isBiometricUnlockEnabledSubscription: AnyCancellable?
    
    init(vault: Vault, preferences: Preferences, keychain: Keychain, dependency: Dependency) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
        self.dependency = dependency
        self.keychainAvailability = keychain.availability
        self.isBiometricUnlockEnabled = preferences.value.isBiometricUnlockEnabled
        self.changeMasterPasswordModel = dependency.changeMasterPasswordModel()
        
        keychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
        
        preferences.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
        
        isBiometricUnlockEnabledSubscription = $isBiometricUnlockEnabled
            .flatMap { isBiometricUnlockEnabled -> AnyPublisher<Bool, Error> in
                if isBiometricUnlockEnabled {
                    return keychain.storeSecret(vault.derivedKey, forKey: Identifier.derivedKey)
                        .map { isBiometricUnlockEnabled }
                        .eraseToAnyPublisher()
                } else {
                    return keychain.deleteSecret(forKey: Identifier.derivedKey)
                        .map { isBiometricUnlockEnabled }
                        .eraseToAnyPublisher()
                }
            }
            .sink { [errorSubject] completion in
                if case .failure = completion {
                    errorSubject.send(.keychainAccessDidFail)
                }
            } receiveValue: { isBiometricUnlockEnabled in
                preferences.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
            }
    }
    
}

#if DEBUG
class SettingsModelStub: SettingsModelRepresentable {
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool
    
    var error: AnyPublisher<SettingModelError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(changeMasterPasswordModel: ChangeMasterPasswordModel, keychainAvailability: Keychain.Availability, isBiometricUnlockEnabled: Bool) {
        self.changeMasterPasswordModel = changeMasterPasswordModel
        self.keychainAvailability = keychainAvailability
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func setBiometricUnlock(isEnabled: Bool) {}
    
}
#endif
