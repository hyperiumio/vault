import SwiftUI

struct SecureItemEditView: View {
    
    let model: SecureItemEditModel
    
    var body: some View {
        switch model {
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
            GenericItemEditView(model: model)
        }
    }
    
}
