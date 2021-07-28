import Foundation

@MainActor
class BiometrySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool {
        didSet {
            Task {
                await dependency.settingsService.save(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
            }
        }
    }
    
    let biometryType: BiometryType
    
    private let dependency: Dependency
    
    init(biometryType: BiometryType, isBiometricUnlockEnabled: Bool, dependency: Dependency) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        self.dependency = dependency
    }
    
}
