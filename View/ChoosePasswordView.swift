import Localization
import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(macOS)
    var body: some View {
        PageNavigationView(LocalizedString.continue, isEnabled: !model.password.isEmpty, action: model.choosePassword) {
            VStack {
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
                
                Spacer()
                
                NativeTextField(title: LocalizedString.enterMasterPassword, text: $model.password, textStyle: .title2, action: model.choosePassword)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
                
                Spacer()
            }
        }
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        PageNavigationView(LocalizedString.continue, isEnabled: !model.password.isEmpty, action: model.choosePassword) {
            VStack {
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
                
                Spacer()
                
                SecureField(LocalizedString.enterMasterPassword, text: $model.password)
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
