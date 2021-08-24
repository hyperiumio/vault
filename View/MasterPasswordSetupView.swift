import SwiftUI

struct MasterPasswordSetupView: View {
    
    @ObservedObject private var state: MasterPasswordSetupState
    @FocusState private var isPasswordFieldFocused: Bool
    private let presentsPasswordConfirmation: Binding<Bool>
    
    init(_ state: MasterPasswordSetupState) {
        self.state = state
        
        self.presentsPasswordConfirmation = Binding {
            state.presentsPasswordConfirmation
        } set: { presentsPasswordConfirmation in
            state.presentsPasswordConfirmation = presentsPasswordConfirmation
        }
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.canChoosePassword) {
            isPasswordFieldFocused = false
            state.choosePasswordIfSecure()
        } image: {
            Image(.masterPasswordSetupImage)
        } title: {
            Text(.chooseMasterPasswordTitle)
        } description: {
            Text(.chooseMasterPasswordDescription)
        } input: {
            VStack {
                SecureField(.enterMasterPassword, text: $state.masterPassword, prompt: nil)
                    .textFieldStyle(.plain)
                    .font(.title2)
                    .disabled(!state.canEnterPassword)
                    .focused($isPasswordFieldFocused)
                
                ProgressView()
                    .opacity(state.isCheckingPasswordSecurity ? 1 : 0)
            }
        } button: {
            Text(.continue)
        }
        .alert(.insecurePasswordTitle, isPresented: presentsPasswordConfirmation) {
            Button(.cancel, role: .cancel) {
                state.presentsPasswordConfirmation = false
            }
            
            Button(.continue) {
                state.choosePassword()
            }
        } message: {
            Text(.insecurePasswordDescription)
        }
    }
    
}

#if DEBUG
struct MasterPasswordSetupViewPreview: PreviewProvider {
    
    static let state = MasterPasswordSetupState(service: .stub)
    
    static var previews: some View {
        MasterPasswordSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        MasterPasswordSetupView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
