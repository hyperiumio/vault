import Localization
import SwiftUI

struct LockedView<Model>: View where Model: LockedModelRepresentable {
    
    @ObservedObject var model: Model
    
    private let useBiometricsOnAppear: Bool
    
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
        .onAppear {
            if useBiometricsOnAppear {
                model.loginWithBiometrics()
            }
        }
    }
    
    init(_ model: Model, useBiometricsOnAppear: Bool) {
        self.model = model
        self.useBiometricsOnAppear = useBiometricsOnAppear
    }
    
}

extension LockedModelRepresentable {
    
    var textInputDisabled: Bool {
        status == .unlocking
    }
    
}
