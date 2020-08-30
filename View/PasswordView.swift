import Localization
import SwiftUI

struct PasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemSecureField(LocalizedString.password, text: $model.password, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}

#if DEBUG
struct PasswordViewPreviews: PreviewProvider {
    
    static let model = PasswordModelStub(password: "")
    @State static var isEditable = false
    
    static var previews: some View {
        PasswordView(model, isEditable: $isEditable)
    }
    
}
#endif
