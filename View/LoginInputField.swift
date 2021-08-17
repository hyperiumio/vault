import SwiftUI

struct LoginInputField: View {
    
    @ObservedObject private var state: LoginItemState
    
    init(_ state: LoginItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(.username) {
            TextField(.usernameOrEmail, text: $state.username)
                #if os(iOS)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                #endif
        }
        
        Field(.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
        
        Field(.url) {
            TextField(.exampleURL, text: $state.url)
                #if os(iOS)
                .keyboardType(.URL)
                .textContentType(.URL)
                #endif
        }
    }
    
}

#if DEBUG
struct LoginInputFieldPreview: PreviewProvider {
    
    static let state = LoginItemState(service: .stub)
    
    static var previews: some View {
        List {
            LoginInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
