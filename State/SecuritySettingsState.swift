import Event
import Foundation

@MainActor
class SecuritySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool
    
    let biometryType: AppServiceBiometry
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        self.biometryType = .faceID
        self.isBiometricUnlockEnabled = true
        
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

extension SecuritySettingsState {
    
    enum Input {
        
        case biometricUnlock(isEnabled: Bool)
        
    }
    
}
