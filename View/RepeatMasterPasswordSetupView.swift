import SwiftUI

struct RepeatMasterPasswordSetupView: View {
    
    @ObservedObject private var state: RepeatMasterPasswordSetupState
    @FocusState private var isPasswordFieldFocused: Bool
    private let presentsPasswordMismatch: Binding<Bool>
    
    init(_ state: RepeatMasterPasswordSetupState) {
        self.state = state
        
        self.presentsPasswordMismatch = Binding {
            state.presentsPasswordMismatch
        } set: { presentsPasswordMismatch in
            state.presentsPasswordMismatch = presentsPasswordMismatch
        }
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.canChooseRepeatedPassword) {
            isPasswordFieldFocused = false
            state.checkRepeatedPassword()
        } image: {
            Image(.masterPasswordRepeatImage)
        } title: {
            Text(.repeatMasterPasswordTitle)
        } description: {
            Text(.repeatMasterPasswordDescription)
        } input: {
            SecureField(.enterMasterPassword, text: $state.repeatedPassword, prompt: nil)
                .textFieldStyle(.plain)
                .font(.title2)
                .disabled(!state.canEnterPassword)
                .focused($isPasswordFieldFocused)
        } button: {
            Text(.continue)
        }
        .alert(.passwordMismatchTitle, isPresented: presentsPasswordMismatch) {

        } message: {
            Text(.passwordMismatchDescription)
        }
    }
    
}

#if DEBUG
struct RepeatMasterPasswordSetupViewPreview: PreviewProvider {
    
    static let state = RepeatMasterPasswordSetupState(masterPassword: "foo")
    
    static var previews: some View {
        RepeatMasterPasswordSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        RepeatMasterPasswordSetupView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
