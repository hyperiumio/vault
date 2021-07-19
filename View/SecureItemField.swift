import Model
import SwiftUI

struct SecureItemField: View {
    
    private let item: SecureItem
    
    init(_ item: SecureItem) {
        self.item = item
    }
    
    var body: some View {
        switch item {
        case .password(let passwordItem):
            PasswordField(passwordItem)
        case .login(let loginItem):
            LoginField(loginItem)
        case .file(let fileItem):
            FileField(fileItem)
        case .note(let noteItem):
            NoteField(noteItem)
        case .bankCard(let bankCardItem):
            BankCardField(bankCardItem)
        case .wifi(let wifiItem):
            WifiField(wifiItem)
        case .bankAccount(let bankAccountItem):
            BankAccountField(bankAccountItem)
        case .custom(let customItem):
            CustomField(customItem)
        }
    }
    
}
