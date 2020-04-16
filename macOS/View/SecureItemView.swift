import SwiftUI

struct SecureItemView: View {
    
    let secureItemModel: SecureItemModel
    
    var body: some View {
        switch secureItemModel {
        case .login(let model):
            return LoginView(model: model).eraseToAnyView()
        case .password(let model):
            return PasswordView(model: model).eraseToAnyView()
        case .file(let model):
            return FileView(model: model).eraseToAnyView()
        }
    }
    
}
