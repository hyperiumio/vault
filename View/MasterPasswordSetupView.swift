import SwiftUI

struct MasterPasswordSetupView: View {
    
    @ObservedObject private var state: MasterPasswordSetupState
    @FocusState private var isPasswordFieldFocused: Bool
    private let presentsPasswordConfirmation: Binding<Bool>
    
    init(_ state: MasterPasswordSetupState) {
        self.state = state
        
        self.presentsPasswordConfirmation = Binding {
            state.status == .needsPasswordConfirmation
        } set: { presentsPasswordConfirmation in
            if presentsPasswordConfirmation {
                state.presentPasswordConfirmation()
            } else {
                state.dismissPasswordConfimation()
            }
        }
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.status == .passwordInput) {
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
                PasswordInput(.enterMasterPassword, password: $state.masterPassword)
                    .disabled(state.status != .passwordInput)
                    .focused($isPasswordFieldFocused)
                
                ProgressView()
                    .opacity(state.status == .checkingPasswordSecurity ? 1 : 0)
            }
        } button: {
            Text(.continue)
        }
        .alert(.insecurePasswordTitle, isPresented: presentsPasswordConfirmation) {
            Button(.cancel, role: .cancel) {
                state.dismissPasswordConfimation()
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
