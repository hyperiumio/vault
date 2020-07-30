import Localization
import SwiftUI

struct LoginEditView<Model>: View where Model: LoginEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.user, text: $model.user)
            
            Divider()
            
            SecureItemEditSecureField(title: LocalizedString.password, text: $model.password)
            
            Divider()
            
            SecureItemEditField(title: LocalizedString.url, text: $model.url)
        }
    }
    
}

#if DEBUG
class LoginEditModelStub: LoginEditModelRepresentable {
    
    var user = ""
    var password = ""
    var url = ""
    
}

struct LoginEditViewPreview: PreviewProvider {
    
    static let model = LoginEditModelStub()
    
    static var previews: some View {
        LoginEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
