import Foundation

@MainActor
class BiometricUnlockSetupState: ObservableObject {
    
    @Published private(set) var status = Status.input
    @Published var isEnabled: Bool
    let biometry: Biometry
    
    init(biometry: Biometry, isEnabled: Bool? = nil) {
        self.biometry = biometry
        self.isEnabled = isEnabled ?? false
    }
    
    func confirm() {
        status = .setupComplete
    }
    
}

extension BiometricUnlockSetupState {
    
    enum Biometry {
        
        case touchID
        case faceID
        
    }
    
    enum Status {
        
        case input
        case setupComplete
        
    }
    
}
