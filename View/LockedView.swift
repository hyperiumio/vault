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
                
                switch model.keychainAvailability {
                case .touchID:
                    BiometricUnlockButton(.touchID, action: model.loginWithBiometrics)
                case .faceID:
                    BiometricUnlockButton(.faceID, action: model.loginWithBiometrics)
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

private extension LockedView {
    
    struct BiometricUnlockButton: View {
        
        private let biometricType: BiometricType
        private let action: () -> Void
        
        init(_ biometricType: BiometricType, action: @escaping () -> Void) {
            self.biometricType = biometricType
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                BiometricIcon(biometricType)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
    }
    
}

private extension LockedModelRepresentable {
    
    var textInputDisabled: Bool {
        status == .unlocking
    }
    
}
