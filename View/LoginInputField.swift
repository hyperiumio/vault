import Resource
import SwiftUI

struct LoginInputField: View {
    
    @ObservedObject private var state: LoginItemState
    
    init(_ state: LoginItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(Localized.username) {
            TextField(Localized.usernameOrEmail, text: $state.username)
                #if os(iOS)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                #endif
        }
        
        Field(Localized.password) {
            SecureField(Localized.password, text: $state.password, prompt: nil)
                .textContentType(.password)
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
        
        Field(Localized.url) {
            TextField(Localized.exampleURL, text: $state.url)
                #if os(iOS)
                .keyboardType(.URL)
                .textContentType(.URL)
                #endif
        }
    }
    
}

#if DEBUG
struct LoginInputFieldPreview: PreviewProvider {
    
    static let service = PasswordServiceStub()
    static let state = LoginItemState(dependency: service)
    
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
