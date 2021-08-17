import SwiftUI

struct WifiInputField: View {
    
    @ObservedObject private var state: WifiItemState
    
    init(_ state: WifiItemState) {
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
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
    }
    
}

#if DEBUG
struct WifiInputFieldPreview: PreviewProvider {
    
    static let state = WifiItemState(service: .stub)
    
    static var previews: some View {
        List {
            WifiInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
