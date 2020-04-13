import SwiftUI

struct VaultItemElementView: View {
    
    let secureItem: VaultItemModel.SecureItem
    
    var body: some View {
        switch secureItem {
        case .login(let model):
            return LoginView(model: model).eraseToAnyView()
        case .password(let model):
            return PasswordView(model: model).eraseToAnyView()
        case .file(let model):
            return FileView(model: model).eraseToAnyView()
        }
    }
    
}
