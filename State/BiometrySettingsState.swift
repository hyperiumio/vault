import Collection
import Foundation

@MainActor
class BiometrySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool {
        didSet {
            let input = Input.biometricUnlock(isEnabled: isBiometricUnlockEnabled)
            Task {
                await inputs.enqueue(input)
            }
        }
    }
    
    let biometryType: BiometryType
    private let inputs = Queue<Input>()
    
    init(biometryType: BiometryType, isBiometricUnlockEnabled: Bool, service: AppServiceProtocol) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
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
