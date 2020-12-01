import Crypto
import Localization
import SwiftUI

struct EnableBiometricUnlockView<Model>: View where Model: EnableBiometricUnlockModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: EnableBiometricUnlockError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        PageNavigationView(LocalizedString.continue, enabledIntensions: [.backward, .forward]) { intension in
            switch intension {
            case .forward:
                model.done()
            case .backward:
                model.dismiss()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack {
                    switch model.biometryType {
                    case .touchID:
                        Content(image: .touchID, title: LocalizedString.enableTouchIDUnlock, description: LocalizedString.unlockWithTouchIDDescription, isEnabled: $model.isEnabled)
                    case .faceID:
                        Content(image: .faceID, title: LocalizedString.enableFaceIDUnlock, description: LocalizedString.unlockWithFaceIDDescription, isEnabled: $model.isEnabled)
                    }
                }
                
                Spacer()
            }
        }
    }
    
}

private struct Content: View {
    
    private let image: Image
    private let title: String
    private let description: String
    private let isEnabled: Binding<Bool>
    
    init(image: Image, title: String, description: String, isEnabled: Binding<Bool>) {
        self.image = image
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            Spacer().frame(height: 40)
            
            HStack {
                Text(LocalizedString.enableTouchIDUnlock)
                    .font(.title)
                
                Toggle(LocalizedString.enableTouchIDUnlock, isOn:isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
            }
            
            Spacer().frame(height: 10)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondaryLabel)
                .multilineTextAlignment(.center)
        }
    }
    
}

private extension EnableBiometricUnlockView {
    
    static func title(for error: EnableBiometricUnlockError, biometryType: Keychain.BiometryType) -> Text {
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

#if DEBUG
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
