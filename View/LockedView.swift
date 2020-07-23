import Localization
import SwiftUI

struct LockedView: View {
    
    @ObservedObject var model: LockedModel
    
    var body: some View {
        VStack {
            UnlockField(title: LocalizedString.masterPassword, text: $model.password, unlock: model.loginWithMasterPassword)
                .frame(maxWidth: 300)
                .disabled(model.textInputDisabled)
            
            Spacer()
                .frame(maxHeight: 30)
            
            switch model.biometricUnlockAvailability {
            case .touchID:
                BiometricUnlockButton(biometricType: .touchID, action: model.loginWithBiometrics)
            case .faceID:
                BiometricUnlockButton(biometricType: .faceID, action: model.loginWithBiometrics)
            case .notAvailable, .notEnrolled:
                EmptyView()
            }

            Spacer()
                .frame(maxHeight: 30)
            
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
    
}
