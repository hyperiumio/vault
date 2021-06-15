import Crypto
import SwiftUI

#warning("Todo")
struct EnableBiometricUnlockView<Model>: View where Model: EnableBiometricUnlockModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: EnableBiometricUnlockError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        PageNavigationView(.continue, enabledIntensions: [.backward, .forward]) { intension in
            switch intension {
            case .forward:
                break
         //       model.done()
            case .backward:
                break
         //       model.dismiss()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack {
                    switch model.biometryType {
                    case .touchID:
                        Content(imageName: .touchid, title: .enableTouchIDUnlock, description: .unlockWithTouchIDDescription, isEnabled: $model.isEnabled)
                    case .faceID:
                        Content(imageName: .faceid, title: .enableFaceIDUnlock, description: .unlockWithFaceIDDescription, isEnabled: $model.isEnabled)
                    }
                }
                
                Spacer()
            }
        }
    }
    
}

private struct Content: View {
    
    private let imageName: String
    private let title: LocalizedStringKey
    private let description: LocalizedStringKey
    private let isEnabled: Binding<Bool>
    
    init(imageName: String, title: LocalizedStringKey, description: LocalizedStringKey, isEnabled: Binding<Bool>) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            Spacer().frame(height: 40)
            
            HStack {
                Text(.enableTouchIDUnlock)
                    .font(.title)
                
                Toggle(.enableTouchIDUnlock, isOn:isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
            }
            
            Spacer().frame(height: 10)
            
            Text(description)
                .font(.body)
    //            .foregroundColor(.secondaryLabel)
                .multilineTextAlignment(.center)
        }
    }
    
}

private extension EnableBiometricUnlockView {
    
    static func title(for error: EnableBiometricUnlockError, biometryType: Keychain.BiometryType) -> Text {
        switch (error, biometryType) {
        case (.didFailEnabling, .touchID):
            return Text(.touchIDActivationFailed)
        case (.didFailEnabling, .faceID):
            return Text(.faceIDActivationFailed)
        case (.didFailDisabling, .touchID):
            return Text(.touchIDDeactivationFailed)
        case (.didFailDisabling, .faceID):
            return Text(.faceIDDeactivationFailed)
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
