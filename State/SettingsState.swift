import Foundation
import Model

protocol SettingsDependency {
    
    var biometryType: BiometryType? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func biometrySettingsDependency() -> BiometrySettingsDependency
    func masterPasswordSettingsDependency() -> MasterPasswordSettingsDependency
    
}

@MainActor
class SettingsState: ObservableObject {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    let masterPasswordSettingsState: MasterPasswordSettingsState
    
    private let dependency: SettingsDependency
    
    init(dependency: SettingsDependency) {
        let masterPasswordSettingsDependency = dependency.masterPasswordSettingsDependency()
        
        self.dependency = dependency
        self.masterPasswordSettingsState = MasterPasswordSettingsState(dependency: masterPasswordSettingsDependency)
    }
    
    func load() async {
        guard let biometryType = await dependency.biometryType else {
            return
        }
        
        let isBiometricUnlockEnabled = await dependency.isBiometricUnlockEnabled
        let biometrySettingdependency = dependency.biometrySettingsDependency()
        biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, dependency: biometrySettingdependency)
    }
    
}
