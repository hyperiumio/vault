import Localization
import SwiftUI

struct PasswordEditView<Model>: View where Model: PasswordEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        SecureItemEditSecureField(title: LocalizedString.password, text: $model.password)
    }
    
}

#if DEBUG
class PasswordEditModelStub: PasswordEditModelRepresentable {
    
    var password = ""
    
}

struct PasswordEditViewProvider: PreviewProvider {
    
    static let model = PasswordEditModelStub()
    
    static var previews: some View {
        PasswordEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif
