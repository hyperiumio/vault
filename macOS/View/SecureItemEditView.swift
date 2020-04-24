import SwiftUI

struct SecureItemEditView: View {
    
    let secureItemModel: SecureItemEditModel
    
    var body: some View {
        switch secureItemModel {
        case .login(let model):
            return LoginEditView(model: model).eraseToAnyView()
        case .password(let model):
            return PasswordEditView(model: model).eraseToAnyView()
        case .file(let model):
            return FileEditView(model: model).eraseToAnyView()
        }
    }
    
}
