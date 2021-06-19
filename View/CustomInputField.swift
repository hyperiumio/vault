import SwiftUI
#warning("TODO")
struct CustomInputField<S>: View where S: CustomStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        EditSecureItemField(.description, text: $state.description) {
            TextField(.value, text: $state.value)
        }
         */
    }
    
}

#if DEBUG
struct CustomInputFieldPreview: PreviewProvider {
    
    static let state = CustomStateStub()
    
    static var previews: some View {
        List {
            CustomInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
