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
        case .note(let model):
            return NoteEditView(model: model).eraseToAnyView()
        case .bankCard(let model):
            return BankCardEditView(model: model).eraseToAnyView()
        case .wifi(let model):
            return WifiEditView(model: model).eraseToAnyView()
        case .bankAccount(let model):
            return BankAccountEditView(model: model).eraseToAnyView()
        case .customField(let model):
            return CustomFieldEditView(model: model).eraseToAnyView()
        }
    }
    
}
