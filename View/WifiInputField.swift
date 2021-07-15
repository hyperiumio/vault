import SwiftUI

struct WifiInputField: View {
    
    @ObservedObject private var state: WifiState
    
    init(_ state: WifiState) {
        self.state = state
    }
    
    var body: some View {
        Field(.name) {
            TextField(.accountHolder, text: $state.name)
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
        
        Field(.password) {
            SecureField(.password, text: $state.password, prompt: nil)
                .textContentType(.password)
        }
    }
    
}
