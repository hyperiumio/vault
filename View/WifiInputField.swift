import SwiftUI

struct WifiInputField<WifiInputState>: View where WifiInputState: WifiStateRepresentable {
    
    @ObservedObject private var state: WifiInputState
    
    init(_ state: WifiInputState) {
        self.state = state
    }
    
    var body: some View {
        Field(.name) {
            TextField(.accountHolder, text: $state.name)
                .keyboardType(.asciiCapable)
        }
        
        Field (.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
        }
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
