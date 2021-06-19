import SwiftUI
#warning("TODO")
struct PasswordInputField<PasswordInputState>: View where PasswordInputState: PasswordStateRepresentable {
    
    @ObservedObject private var state: PasswordInputState
    
    init(_ state: PasswordInputState) {
        self.state = state
    }
    
    var body: some View {
        Field (.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
        }
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
