import Model
import SwiftUI

struct SecureItemField: View {
    
    private let item: SecureItem
    
    init(_ item: SecureItem) {
        self.item = item
    }
    
    var body: some View {
        switch item {
        case let .password(passwordItem):
            PasswordField(passwordItem)
        case let .login(loginItem):
            LoginField(loginItem)
        case let .file(fileItem):
            FileField(fileItem)
        case let .note(noteItem):
            NoteField(noteItem)
        case let .bankCard(bankCardItem):
            BankCardField(bankCardItem)
        case let .wifi(wifiItem):
            WifiField(wifiItem)
        case let .bankAccount(bankAccountItem):
            BankAccountField(bankAccountItem)
        case let .custom(customItem):
            CustomField(customItem)
        }
    }
    
}
