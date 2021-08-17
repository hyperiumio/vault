import Collection
import Foundation
import Model

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    @Published var biometrySettingsState: BiometrySettingsState?
    
    let masterPasswordSettingsState: MasterPasswordSettingsState
    
    private let inputs = Queue<Input>()
    
    init(service: AppServiceProtocol) {
        self.masterPasswordSettingsState = MasterPasswordSettingsState(service: service)
        
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
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
        Task {
            await inputs.enqueue(.load)
        }
    }
    
}

extension SettingsState {
    
    enum Input {
        
        case load
        
    }
    
}
