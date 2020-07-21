import Localization
import SwiftUI

struct LockedView: View {
    
    @ObservedObject var model: LockedModel
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
            
            SecureField(LocalizedString.masterPassword, text: $model.password, onCommit: model.loginWithMasterPassword)
                .frame(maxWidth: 300)
                .disabled(model.textInputDisabled)
            
            Button(LocalizedString.unlockVault, action: model.loginWithMasterPassword)
                .disabled(model.decryptMasterKeyButtonDisabled)
            
            switch model.biometricUnlockAvailability {
            case .touchID:
                BiometricUnlockButton(biometricType: .touchID, action: model.loginWithBiometrics)
            case .faceID:
                BiometricUnlockButton(biometricType: .faceID, action: model.loginWithBiometrics)
            case .notAvailable, .notEnrolled:
                EmptyView()
            }

            switch model.status {
            case .none:
                EmptyView()
            case .unlocking:
                ProgressView()
            case .invalidPassword:
                Text(LocalizedString.wrongPassword)
                    .padding()
            case .unlockDidFail:
                Text(LocalizedString.unlockFailed)
            }
        }
    }
    
}
