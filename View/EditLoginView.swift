import SwiftUI

struct EditLoginView<S>: View where S: LoginStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        EditItemTextField(.username, placeholder: .usernameOrEmail, text: $state.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        EditItemSecureField(.password, placeholder: .password, text: $state.password, generatorAvailable: true)
            .textContentType(.password)
        
        EditItemTextField(.url, placeholder: .exampleURL, text: $state.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    
}

#if DEBUG
struct EditLoginViewPreview: PreviewProvider {
    
    static let state = LoginStateStub()
    
    static var previews: some View {
        List {
            EditLoginView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
