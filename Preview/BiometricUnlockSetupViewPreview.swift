#if DEBUG
import SwiftUI

struct BiometricUnlockSetupViewPreview: PreviewProvider {
    
    static let model = BiometricUnlockSetupModelStub(isUnlockEnabled: false)
    
    static var previews: some View {
        BiometricUnlockSetupView(model)
    }
    
}
#endif
