import SwiftUI
#warning("TODO")
struct WifiInputField<S>: View where S: WifiStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        EditItemTextField(.name, placeholder: .name, text: $state.name)
            .keyboardType(.asciiCapable)
        
        EditItemSecureField(.password, placeholder: .password, text: $state.password, generatorAvailable: true)
         */
    }
    
}

#if DEBUG
struct WifiInputFieldPreview: PreviewProvider {
    
    static let state = WifiStateStub()
    
    static var previews: some View {
        List {
            WifiInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
