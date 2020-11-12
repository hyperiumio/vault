import Localization
import SwiftUI

struct EnableBiometricUnlockView<Model>: View where Model: EnableBiometricUnlockModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: EnableBiometricUnlockError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                switch model.biometryType {
                case .touchID:
                    Text(LocalizedString.unlockWithTouchID)

                case .faceID:
                    Text(LocalizedString.unlockWithFaceID)
                }
            }
            .font(.title)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: model.enabledBiometricUnlock) {
                    switch model.biometryType {
                    case .touchID:
                        Text(LocalizedString.enableTouchIDUnlock)

                    case .faceID:
                        Text(LocalizedString.enableFaceIDUnlock)
                    }
                }
                .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fill))
                
                Button(LocalizedString.setUpLater, action: model.disableBiometricUnlock)
                    .font(.headline)
            }
        }
    }
    
}

private extension EnableBiometricUnlockView {
    
    static func title(for error: EnableBiometricUnlockError, biometryType: BiometryType) -> Text {
        switch (error, biometryType) {
        case (.didFailEnabling, .touchID):
            return Text(LocalizedString.touchIDActivationFailed)
        case (.didFailEnabling, .faceID):
            return Text(LocalizedString.faceIDActivationFailed)
        case (.didFailDisabling, .touchID):
            return Text(LocalizedString.touchIDDeactivationFailed)
        case (.didFailDisabling, .faceID):
            return Text(LocalizedString.faceIDDeactivationFailed)
        }
    }
    
}

#if os(iOS) && DEBUG
struct EnableBiometricUnlockViewPreview: PreviewProvider {
    
    static let model = EnableBiometricUnlockModelStub()
    
    static var previews: some View {
        Group {
            EnableBiometricUnlockView(model)
                .preferredColorScheme(.light)
            
            EnableBiometricUnlockView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
