import Localization
import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(macOS)
    private var passwordTextMinHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: .title2)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    #endif
    
    #if os(iOS)
    private var passwordTextMinHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: .title2).lineHeight
    }
    #endif
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 10) {
                Text(LocalizedString.chooseMasterPassword)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedString.chooseMasterPasswordDescription)
                    .font(.body)
                    .foregroundColor(.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
            
            SecureField(LocalizedString.enterMasterPassword, text: $model.password)
                .textContentType(.oneTimeCode)
                .font(.title2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(minHeight: passwordTextMinHeight)
            
            Spacer()
            
            Button(LocalizedString.continue, action: model.choosePassword)
                .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fill))
                .disabled(model.password.isEmpty)
        }
    }
    
}

#if DEBUG
struct ChoosePasswordViewProvider: PreviewProvider {
    
    static let model = ChoosePasswordModelStub()
    
    static var previews: some View {
        Group {
            ChoosePasswordView(model)
                .preferredColorScheme(.light)
            
            ChoosePasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
