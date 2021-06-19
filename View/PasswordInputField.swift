import SwiftUI
#warning("TODO")
struct PasswordInputField<S>: View where S: PasswordStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        EditItemSecureField(.password, placeholder: .password, text: $state.password, generatorAvailable: true)
         */
    }

}

#if DEBUG
struct PasswordInputFieldPreview: PreviewProvider {
    
    static let state = PasswordStateStub()
    
    static var previews: some View {
        List {
            PasswordInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
