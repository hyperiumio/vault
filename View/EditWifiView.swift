import SwiftUI

struct EditWifiView<S>: View where S: WifiStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        EditItemTextField(.name, placeholder: .name, text: $state.name)
            .keyboardType(.asciiCapable)
        
        EditItemSecureField(.password, placeholder: .password, text: $state.password, generatorAvailable: true)
    }
    
}

#if DEBUG
struct EditWifiViewPreview: PreviewProvider {
    
    static let state = WifiStateStub()
    
    static var previews: some View {
        List {
            EditWifiView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
