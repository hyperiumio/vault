import Foundation
import Model

@MainActor
class SettingsState: ObservableObject {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    let masterPasswordSettingsState: MasterPasswordSettingsState
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.masterPasswordSettingsState = MasterPasswordSettingsState(dependency: dependency)
        self.dependency = dependency
    }
    
    func load() async {
        if let biometryType = await dependency.settingsService.availableBiometry {
            let isBiometricUnlockEnabled = await dependency.settingsService.isBiometricUnlockEnabled
            biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, dependency: dependency)
        }
    }
    
}
