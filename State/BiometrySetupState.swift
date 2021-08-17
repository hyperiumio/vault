import Foundation

@MainActor
class BiometrySetupState: ObservableObject {
    
    @Published var isBiometricUnlockEnabled = false
    let biometryType: BiometryType
    let done: () async -> Void
    
    init(biometryType: BiometryType, done: @escaping () async -> Void) {
        self.biometryType = biometryType
        self.done = done
    }

    
}
