import SwiftUI

struct ChoosePasswordView<ChoosePasswordState>: View where ChoosePasswordState: ChoosePasswordStateRepresentable {
    
    @ObservedObject private var state: ChoosePasswordState
    
    init(_ state: ChoosePasswordState) {
        self.state = state
    }
    
    var body: some View {
        PageNavigationView(.continue, isEnabled: !state.password.isEmpty) {
            async {
                await state.choosePassword()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.chooseMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.chooseMasterPasswordDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $state.password, prompt: nil)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
    
}

#if DEBUG
struct ChoosePasswordViewProvider: PreviewProvider {
    
    static let state = ChoosePasswordStateStub()
    
    static var previews: some View {
        ChoosePasswordView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
