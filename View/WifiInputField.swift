import Resource
import SwiftUI

struct WifiInputField: View {
    
    @ObservedObject private var state: WifiItemState
    
    init(_ state: WifiItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(Localized.name) {
            TextField(Localized.accountHolder, text: $state.name)
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
        
        Field(Localized.password) {
            SecureField(Localized.password, text: $state.password, prompt: nil)
                .textContentType(.password)
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
    }
    
}
