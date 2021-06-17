import SwiftUI

struct EditPasswordView<S>: View where S: PasswordStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        EditItemSecureField(.password, placeholder: .password, text: $state.password, generatorAvailable: true)
    }

}

#if DEBUG
struct EditPasswordViewPreview: PreviewProvider {
    
    static let state = PasswordStateStub()
    
    static var previews: some View {
        List {
            EditPasswordView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
