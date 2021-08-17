import SwiftUI

struct RepeatMasterPasswordSetupView: View {
    
    @ObservedObject private var state: RepeatMasterPasswordSetupState
    
    init(_ state: RepeatMasterPasswordSetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            Image("Placeholder")
            
            Text(.chooseMasterPassword)
                .font(.title)
            
            Text(.repeatMasterPassword)
                .font(.body)
                .foregroundStyle(.secondary)
            
            SecureField(.repeatMasterPasswordDescription, text: $state.password, prompt: nil)
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

    }
    
}
