import Crypto
import Foundation
import Model

@MainActor
protocol SettingsDependency {
    
    var keychainAvailablity: KeychainAvailability { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    var biometrySettingsDependency: BiometrySettingsDependency { get }
    var masterPasswordSettingsDependency: MasterPasswordSettingsDependency { get }
    
}

@MainActor
class SettingsState: ObservableObject {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    let masterPasswordSettingsState: MasterPasswordSettingsState
    
    private let dependency: SettingsDependency
    
    init(dependency: SettingsDependency) {
        self.dependency = dependency
        self.masterPasswordSettingsState = MasterPasswordSettingsState(dependency: dependency.masterPasswordSettingsDependency)
    }
    
    func load() async {
        switch await dependency.keychainAvailablity {
        case .notAvailable, .notEnrolled:
            biometrySettingsState = nil
        case .enrolled(let biometryType):
            let isBiometricUnlockEnabled = await dependency.isBiometricUnlockEnabled
            biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, dependency: dependency.biometrySettingsDependency)
        }
    }
    
}
