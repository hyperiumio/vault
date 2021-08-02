import Foundation

@MainActor
class BiometrySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool {
        didSet {
            Task {
                await service.save(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
            }
        }
    }
    
    let biometryType: BiometryType
    
    private let service: AppServiceProtocol
    
    init(biometryType: BiometryType, isBiometricUnlockEnabled: Bool, service: AppServiceProtocol) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        self.service = service
    }
    
}
