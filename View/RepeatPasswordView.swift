import Localization
import SwiftUI

#if os(iOS)
struct RepeatPasswordView<Model>: View where Model: RepeatPasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: RepeatPasswordError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    private var passwordTextMinHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        return ceil(font.lineHeight)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Text(LocalizedString.repeatMasterPassword)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedString.repeatMasterPasswordDescription)
                    .font(.body)
                    .foregroundColor(.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
            
            SecureField(LocalizedString.enterMasterPassword, text: $model.repeatedPassword)
                .textContentType(.oneTimeCode)
                .font(.title2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(minHeight: passwordTextMinHeight)
            
            Spacer()
            
            Button(LocalizedString.continue, action: model.validatePassword)
                .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fill))
                .disabled(model.repeatedPassword.isEmpty)
        }
        .onReceive(model.error) { error in
            self.error = error
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
    }
    
}
#endif

#if os(iOS)
private extension RepeatPasswordView {
    
    static func title(for error: RepeatPasswordError) -> Text {
        switch error {
        case .invalidPassword:
            return Text(LocalizedString.invalidPassword)
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct RepeatPasswordViewProvider: PreviewProvider {
    
    static let model = RepeatPasswordModelStub()
    
    static var previews: some View {
        Group {
            RepeatPasswordView(model)
                .preferredColorScheme(.light)
            
            RepeatPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
