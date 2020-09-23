import Combine

protocol BiometricUnlockSetupModelRepresentable: ObservableObject, Identifiable {
    
    var isUnlockEnabled: Bool { get set }
    
}

class BiometricUnlockSetupModel: BiometricUnlockSetupModelRepresentable {
    
    @Published var isUnlockEnabled: Bool = false
    
}
