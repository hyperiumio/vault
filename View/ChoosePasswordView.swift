import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(macOS)
    var body: some View {
        PageNavigationView(.continue, isEnabled: !model.password.isEmpty, action: model.choosePassword) {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.chooseMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.chooseMasterPasswordDescription)
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                TextFieldShim(title: .enterMasterPassword, text: $model.password, isSecure: true, textStyle: .title2, alignment: .center, action: model.choosePassword)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
                
                Spacer()
            }
        }
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        PageNavigationView(.continue, isEnabled: !model.password.isEmpty, action: model.choosePassword) {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.chooseMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.chooseMasterPasswordDescription)
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $model.password)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
            }
        }
    }
    #endif
    
}

#if os(macOS)
private typealias TextStyle = NSFont.TextStyle

private extension NSFont.TextStyle {
    
    var lineHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: self)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    
}
#endif
    
#if os(iOS)
private typealias TextStyle = UIFont.TextStyle

private extension UIFont.TextStyle {

    var lineHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: self).lineHeight
    }
    
}
#endif

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
