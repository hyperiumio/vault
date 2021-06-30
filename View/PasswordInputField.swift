import SwiftUI

struct PasswordInputField: View {
    
    @ObservedObject private var state: PasswordState
    
    init(_ state: PasswordState) {
        self.state = state
    }
    
    var body: some View {
        Field (.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
        }
    }

}
