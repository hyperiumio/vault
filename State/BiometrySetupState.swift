import Combine
import Foundation
import Event

@MainActor
class BiometrySetupState: ObservableObject {
    
    @Published private(set) var status = Status.biometrySetup
    @Published var isBiometricUnlockEnabled: Bool
    let biometryType: AppServiceBiometry
    
    init(biometryType: AppServiceBiometry, isBiometricUnlockEnabled: Bool? = nil) {
        self.biometryType = biometryType
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled ?? false
    }
    
    func confirm() {
        status = .setupComplete
    }
    
}

extension BiometrySetupState {
    
    enum Status {
        
        case biometrySetup
        case setupComplete
        
    }
    
}
