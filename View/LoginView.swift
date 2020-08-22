import Localization
import SwiftUI

struct LoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(title: LocalizedString.user, text: $model.username, isEditable: isEditable)
            
            SecureItemSecureField(title: LocalizedString.password, text: $model.password, isEditable: isEditable)
            
            SecureItemTextField(title: LocalizedString.url, text: $model.url, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class LoginModelStub: LoginModelRepresentable {
    
    var username = "john.doe@example.com"
    var password = "123abc"
    var url = "www.example.com"
    
    func copyUsernameToPasteboard() {}
    func copyPasswordToPasteboard() {}
    func copyURLToPasteboard() {}
    
}

struct LoginViewPreviewProvider: PreviewProvider {
    
    static let model = LoginModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        LoginView(model: model, isEditable: $isEditable)
    }
    
}
#endif
