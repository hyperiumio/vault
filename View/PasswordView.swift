import Localization
import SwiftUI

struct PasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemSecureField(title: LocalizedString.password, text: $model.password, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class PasswordModelStub: PasswordModelRepresentable {
    
    var password = "123abc"
    
    func copyPasswordToPasteboard() {}
    
}

struct PasswordViewPreviewProvider: PreviewProvider {
    
    static let model = PasswordModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        List {
            PasswordView(model: model, isEditable: $isEditable)
        }
        .listStyle(GroupedListStyle())
    }
    
}
#endif
