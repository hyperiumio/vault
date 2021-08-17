import SwiftUI

struct MasterPasswordSetupView: View {
    
    @ObservedObject private var state: MasterPasswordSetupState
    
    init(_ state: MasterPasswordSetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Placeholder")
            
            Text(.chooseMasterPassword)
                .font(.title)
            
            Text(.chooseMasterPasswordDescription)
                .font(.body)
                .foregroundStyle(.secondary)
            
            SecureField(.enterMasterPassword, text: $state.password, prompt: nil)
                .font(.title2)
                .textFieldStyle(.plain)
                .textContentType(.oneTimeCode)
            
            Spacer()
            
            Button {
                Task {
                    await state.done()
                }
            } label: {
                Text(.continue)
                    .frame(maxWidth: 400)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .disabled(state.isContinueButtonDisabled)
        }
        .multilineTextAlignment(.center)
    }
    
}
