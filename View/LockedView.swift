import Localization
import SwiftUI

struct LockedView<Model>: View where Model: LockedModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 20) {
            UnlockField(LocalizedString.masterPassword, text: $model.password, action: model.loginWithMasterPassword)
                .frame(maxWidth: 300)
                .disabled(model.textInputDisabled)
            
            switch model.biometricKeychainAvailability {
            case .touchID:
                BiometricUnlockButton(.touchID, action: model.loginWithBiometrics)
            case .faceID:
                BiometricUnlockButton(.faceID, action: model.loginWithBiometrics)
            case .notAvailable, .notEnrolled:
                EmptyView()
            }
            
            switch model.status {
            case .none, .unlocking:
                EmptyView()
            case .invalidPassword:
                ErrorBadge(LocalizedString.wrongPassword)
            case .unlockDidFail:
                ErrorBadge(LocalizedString.unlockFailed)
            }
        }
        .padding()
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}

extension LockedModelRepresentable {
    
    var textInputDisabled: Bool {
        status == .unlocking
    }
    
}

#if DEBUG
struct LockedViewPreviews: PreviewProvider {
    
    static let model = LockedModelStub()
    
    static var previews: some View {
        LockedView(model)
    }
}
#endif
