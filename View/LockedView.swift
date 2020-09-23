import Localization
import SwiftUI

struct LockedView<Model>: View where Model: LockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.scenePhase) private var scenePhase
    
    private let useBiometricsOnAppear: Bool
    
    var body: some View {
        ZStack {
            Color.systemBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                UnlockField(LocalizedString.masterPassword, text: $model.password, action: model.loginWithMasterPassword)
                    .frame(maxWidth: 300)
                    .disabled(model.textInputDisabled)
                
                switch model.biometricKeychainAvailability {
                case .touchID:
                    BiometricUnlockButton(.touchID, action: model.loginWithBiometrics)
                        .foregroundColor(.accentColor)
                case .faceID:
                    BiometricUnlockButton(.faceID, action: model.loginWithBiometrics)
                        .foregroundColor(.accentColor)
                case .notAvailable, .notEnrolled:
                    EmptyView()
                }
                
                switch model.status {
                case .none, .unlocking, .unlocked:
                    EmptyView()
                case .invalidPassword:
                    ErrorBadge(LocalizedString.wrongPassword)
                case .unlockDidFail:
                    ErrorBadge(LocalizedString.unlockFailed)
                }
            }
            .padding()
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .active, useBiometricsOnAppear {
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
