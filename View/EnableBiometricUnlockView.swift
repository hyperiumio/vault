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
            
            VStack {
                switch model.biometryType {
                case .touchID:
                    Content(image: .touchID, title: LocalizedString.unlockWithTouchID, description: LocalizedString.unlockWithTouchIDDescription)
                case .faceID:
                    Content(image: .faceID, title: LocalizedString.unlockWithFaceID, description: LocalizedString.unlockWithFaceIDDescription)
                }
            }
            
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

private struct Content: View {
    
    private let image: Image
    private let title: String
    private let description: String
    
    init(image: Image, title: String, description: String) {
        self.image = image
        self.title = title
        self.description = description
    }
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            Spacer().frame(height: 40)
            
            Text(title)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 10)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondaryLabel)
                .multilineTextAlignment(.center)
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
    
    static let model = EnableBiometricUnlockModelStub(biometryType: .touchID)
    
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
