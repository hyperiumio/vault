import SwiftUI

struct SecureItemView: View {
    
    @ObservedObject private var state: SecureItemState
    
    init(_ state: SecureItemState) {
        self.state = state
    }
    
    var body: some View {
        switch state.value {
        case .login(let loginState):
            LoginInputField(loginState)
        case .password(let passwordState):
            PasswordInputField(passwordState)
        case .file(let fileState):
            FileInputField(fileState)
        case .note(let noteState):
            NoteInputField(noteState)
        case .bankCard(let bankCardState):
            BankCardInputField(bankCardState)
        case .wifi(let wifiState):
            WifiInputField(wifiState)
        case .bankAccount(let bankAccountState):
            BankAccountInputField(bankAccountState)
        case .custom(let customState):
            CustomInputField(customState)
        }
    }
    
}
