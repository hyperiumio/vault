import Localization
import SwiftUI

struct LoginDisplayView<Model>: View where Model: LoginDisplayModelRepresentable  {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemDisplayField(title: LocalizedString.user, content: model.username)
                .onTapGesture(perform: model.copyUsernameToPasteboard)
            
            Divider()
            
            SecureItemDisplaySecureField(title: LocalizedString.password, content: model.password)
                .onTapGesture(perform: model.copyPasswordToPasteboard)
            
            if !model.url.isEmpty {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.url, content: model.url)
                    .onTapGesture(perform: model.copyURLToPasteboard)
            }
        }
    }
    
}

#if DEBUG
class LoginDisplayModelStub: LoginDisplayModelRepresentable {
    
    var username = "john.doe@example.com"
    var password = "123abc"
    var url = "www.example.com"
    
    func copyUsernameToPasteboard() {}
    func copyPasswordToPasteboard() {}
    func copyURLToPasteboard() {}
    
}

struct LoginDisplayViewPreview: PreviewProvider {
    
    static let model = LoginDisplayModelStub()
    
    static var previews: some View {
        LoginDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
