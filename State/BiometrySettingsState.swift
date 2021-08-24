import Event
import Foundation

@MainActor
class BiometrySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool
    
    let biometryType: BiometryType
    private let inputBuffer = EventBuffer<Input>()
    
    init(biometryType: BiometryType, isBiometricUnlockEnabled: Bool, service: AppServiceProtocol) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        
        let propertyStream = $isBiometricUnlockEnabled.values.map(Input.biometricUnlock)
        inputBuffer.enqueue(propertyStream)
        
        Task {
            for await input in inputBuffer.events {
                switch input {
                case let .biometricUnlock(isEnabled):
                    await service.save(isBiometricUnlockEnabled: isEnabled)
                }
            }
        }
    }
    
}

extension BiometrySettingsState {
    
    enum Input {
        
        case biometricUnlock(isEnabled: Bool)
        
    }
    
}
