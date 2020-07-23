import SwiftUI

struct SecureItemEditView: View {
    
    let secureItemModel: SecureItemEditModel
    
    var body: some View {
        switch secureItemModel {
        case .login(let model):
            LoginEditView(model: model)
        case .password(let model):
            PasswordEditView(model: model)
        case .file(let model):
            FileEditView(model: model)
        case .note(let model):
            NoteEditView(model: model)
        case .bankCard(let model):
            BankCardEditView(model: model)
        case .wifi(let model):
            WifiEditView(model: model)
        case .bankAccount(let model):
            BankAccountEditView(model: model)
        case .customField(let model):
            CustomFieldEditView(model: model)
        }
    }
    
}
