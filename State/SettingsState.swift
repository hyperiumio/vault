import Foundation
import Model

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    let masterPasswordSettingsState: MasterPasswordSettingsState
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.masterPasswordSettingsState = MasterPasswordSettingsState(service: service)
        self.service = service
    }
    
    func load() async {
        if let biometryType = await service.availableBiometry {
            let isBiometricUnlockEnabled = await service.isBiometricUnlockEnabled
            biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, service: service)
        }
    }
    
}
