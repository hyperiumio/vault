import SwiftUI

struct RepeatPasswordView<S>: View where S: RepeatPasswordStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var displayError: RepeatPasswordStateError?
    
    init(_ state: S) {
        self.state = state
    }
    
    var enabledIntensions: Set<PageNavigationIntention> {
        state.repeatedPassword.isEmpty ? [.backward] : [.backward, .forward]
    }
    
    var body: some View {
        PageNavigationView(.continue, enabledIntensions: enabledIntensions) { intension in
            switch intension {
            case .forward:
                async {
                    await state.validatePassword()
                }
            case .backward:
                break
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.repeatMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.repeatMasterPasswordDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $state.repeatedPassword, prompt: nil)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Spacer()
                
            }
        }
        .alert(item: $displayError) { error in
            switch error {
            case .invalidPassword:
                let title = Text(.invalidPassword)
                return Alert(title: title)
            }
        }
    }
    
}

#if DEBUG
struct RepeatPasswordViewProvider: PreviewProvider {
    
    static let state = RepeatPasswordStateStub()
    
    static var previews: some View {
        RepeatPasswordView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
