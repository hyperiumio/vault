#if DEBUG
import Combine

class BiometricUnlockSetupModelStub: BiometricUnlockSetupModelRepresentable {
    
    @Published var isUnlockEnabled: Bool
    
    init(isUnlockEnabled: Bool) {
        self.isUnlockEnabled = isUnlockEnabled
    }
    
}
#endif
