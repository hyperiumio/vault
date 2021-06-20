import SwiftUI

struct LoginInputField<LoginInputState>: View where LoginInputState: LoginStateRepresentable {
    
    @ObservedObject private var state: LoginInputState
    
    init(_ state: LoginInputState) {
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
        
        Field (.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
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
    
    static let state = LoginStateStub()
    
    static var previews: some View {
        List {
            LoginInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
