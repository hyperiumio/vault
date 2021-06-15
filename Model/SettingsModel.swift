import Combine
import Crypto
import Foundation
import Preferences
import Persistence

@MainActor
protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    var keychainAvailability: Keychain.Availability { get }
    var isBiometricUnlockEnabled: Bool { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel { get }
    
}

@MainActor
protocol SettingsModelDependency {
     
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel
    
}

@MainActor
class SettingsModel<Dependency: SettingsModelDependency>: SettingsModelRepresentable {
    
    typealias ChangeMasterPasswordModel = Dependency.ChangeMasterPasswordModel
    
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool = true
    
    let changeMasterPasswordModel: ChangeMasterPasswordModel
    
    private let errorSubject = PassthroughSubject<SettingModelError, Never>()
    private var isBiometricUnlockEnabledSubscription: AnyCancellable?
    
    init(store: Store, derivedKey: DerivedKey, preferences: Preferences, keychain: Keychain, dependency: Dependency) {
        fatalError()
    }
    
}

enum SettingModelError: Error {
    
    case keychainAccessDidFail
    
}


#if DEBUG
class SettingsModelStub: SettingsModelRepresentable {
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel
    @Published var keychainAvailability: Keychain.Availability
    @Published var isBiometricUnlockEnabled: Bool
    
    init(changeMasterPasswordModel: ChangeMasterPasswordModel, keychainAvailability: Keychain.Availability, isBiometricUnlockEnabled: Bool) {
        self.changeMasterPasswordModel = changeMasterPasswordModel
        self.keychainAvailability = keychainAvailability
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func setBiometricUnlock(isEnabled: Bool) {}
    
}
#endif
