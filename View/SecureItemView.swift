import SwiftUI

struct SecureItemView: View {
    
    let model: SecureItemModel
    let isEditable: Binding<Bool>
    
    var body: some View {
        switch model {
        case .login(let model):
            LoginView(model: model, isEditable: isEditable)
        case .password(let model):
            PasswordView(model: model, isEditable: isEditable)
        case .file(let model):
            FileView(model: model, isEditable: isEditable)
        case .note(let model):
            NoteView(model: model, isEditable: isEditable)
        case .bankCard(let model):
            BankCardView(model: model, isEditable: isEditable)
        case .wifi(let model):
            WifiView(model: model, isEditable: isEditable)
        case .bankAccount(let model):
            BankAccountView(model: model, isEditable: isEditable)
        case .custom(let model):
            CustomItemView(model: model, isEditable: isEditable)
        }
    }
    
}
