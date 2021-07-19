import Foundation

protocol BiometrySettingsDependency {
    
    func save(isBiometricUnlockEnabled: Bool) async
    
}

@MainActor
class BiometrySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool {
        didSet {
            Task {
                await dependency.save(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
            }
        }
    }
    
    let biometryType: BiometryType
    
    private let dependency: BiometrySettingsDependency
    
    init(biometryType: BiometryType, isBiometricUnlockEnabled: Bool, dependency: BiometrySettingsDependency) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        self.dependency = dependency
    }
    
}
