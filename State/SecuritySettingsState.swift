import Collection
import Foundation

@MainActor
class SecuritySettingsState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled: Bool
    @Published var isWatchUnlockEnabled: Bool
    @Published var hideContent: Bool
    @Published var clearPasteboard: Bool
    @Published private(set) var biometryType: AppServiceBiometry?
    
    private let inputBuffer = AsyncQueue<Input>()
    
    init(service: AppServiceProtocol) {
        self.biometryType = .faceID
        self.isBiometricUnlockEnabled = true
        self.isWatchUnlockEnabled = true
        self.hideContent = true
        self.clearPasteboard = true
        
        let propertyStream = $isBiometricUnlockEnabled.values.map(Input.biometricUnlock)
        inputBuffer.enqueue(propertyStream)
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
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
