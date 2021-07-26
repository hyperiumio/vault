import Resource
import SwiftUI

struct PasswordInputField: View {
    
    @ObservedObject private var state: PasswordItemState
    
    init(_ state: PasswordItemState) {
        self.state = state
    }
    
    var body: some View {
        Field (Localized.password) {
            SecureField(Localized.password, text: $state.password, prompt: nil)
                .textContentType(.password)
            
            PasswordGeneratorView(state: state.passwordGeneratorState) { password in
                state.password = password
            }
        }
    }

}

#if DEBUG
struct PasswordInputFieldPreview: PreviewProvider {
    
    static let service = PasswordServiceStub()
    static let state = PasswordItemState(dependency: service)
    
    static var previews: some View {
        List {
            PasswordInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
