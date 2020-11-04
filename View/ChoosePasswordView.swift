import Localization
import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
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
            
            Text(LocalizedString.chooseMasterPassword)
                .font(.title)
                .multilineTextAlignment(.center)
            
            SecureField(LocalizedString.masterPassword, text: $model.password)
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

#if os(iOS) && DEBUG
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
