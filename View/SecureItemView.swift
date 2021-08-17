import SwiftUI

struct SecureItemView: View {
    
    @ObservedObject private var state: SecureItemState
    
    init(_ state: SecureItemState) {
        self.state = state
    }
    
    var body: some View {
        switch state.value {
        case let .login(loginState):
            LoginInputField(loginState)
        case let .password(passwordState):
            PasswordInputField(passwordState)
        case let .file(fileState):
            FileInputField(fileState)
        case let .note(noteState):
            NoteInputField(noteState)
        case let .bankCard(bankCardState):
            BankCardInputField(bankCardState)
        case let .wifi(wifiState):
            WifiInputField(wifiState)
        case let .bankAccount(bankAccountState):
            BankAccountInputField(bankAccountState)
        case let .custom(customState):
            CustomInputField(customState)
        }
    }
    
}
