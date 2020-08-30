import Localization
import SwiftUI

struct LoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.user, text: $model.username, isEditable: isEditable)
            
            SecureItemSecureField(LocalizedString.password, text: $model.password, isEditable: isEditable)
            
            SecureItemTextField(LocalizedString.url, text: $model.url, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}

#if DEBUG
struct LoginViewPreviews: PreviewProvider {
    
    static let model = LoginModelStub(username: "", password: "", url: "")
    @State static var isEditable = false
    
    static var previews: some View {
        LoginView(model, isEditable: $isEditable)
    }
    
}
#endif
