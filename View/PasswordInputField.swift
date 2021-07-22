import Resource
import SwiftUI

struct PasswordInputField: View {
    
    @ObservedObject private var state: PasswordItemState
    
    init(_ state: PasswordItemState) {
        self.state = state
    }
    
    var body: some View {
        Field (Localized.password) {
            SecureField(Localized.password, text: $state.password, prompt: nil)
                .textContentType(.password)
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
    }

}
