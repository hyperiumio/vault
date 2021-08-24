import Event
import Foundation
import Model

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    let masterPasswordSettingsState: MasterPasswordSettingsState
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        self.masterPasswordSettingsState = MasterPasswordSettingsState(service: service)
        
        Task {
            for await input in inputBuffer.events {
                switch input {
                case .load:
                    guard let biometryType = await service.availableBiometry else { return }
                    
                    let isBiometricUnlockEnabled = await service.isBiometricUnlockEnabled
                    biometrySettingsState = BiometrySettingsState(biometryType: biometryType, isBiometricUnlockEnabled: isBiometricUnlockEnabled, service: service)
                }
            }
        }
    }
    
    func load() {
        inputBuffer.enqueue(.load)
    }
    
}

extension SettingsState {
    
    enum Input {
        
        case load
        
    }
    
}
