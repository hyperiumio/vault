import SwiftUI

struct SecureItemDisplayView: View {
    
    let model: SecureItemDisplayModel
    
    @ViewBuilder var body: some View {
        switch model {
        case .login(let model):
            LoginDisplayView(model: model)
        case .password(let model):
            PasswordDisplayView(model: model)
        case .file(let model):
            FileDisplayView(model: model)
        case .note(let model):
            NoteDisplayView(model: model)
        case .bankCard(let model):
            BankCardDisplayView(model: model)
        case .wifi(let model):
            WifiDisplayView(model: model)
        case .bankAccount(let model):
            BankAccountDisplayView(model: model)
        case .customField(let model):
            CustomFieldDisplayView(model: model)
        }
    }
    
}

