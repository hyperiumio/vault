import Foundation
import Model

protocol SettingsDependency {
    
    var biometryType: BiometryType? { get async }
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
        guard let biometryType = await dependency.biometryType else {
            return
        }
        
        let isBiometricUnlockEnabled = await dependency.isBiometricUnlockEnabled
        biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, dependency: dependency.biometrySettingsDependency)
    }
    
}
