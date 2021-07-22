import Asset
import SwiftUI

struct MasterPasswordSettingsView: View {
    
    @ObservedObject private var state: MasterPasswordSettingsState
    @FocusState private var focusedField: Field?
    
    init(_ state: MasterPasswordSettingsState) {
        self.state = state
    }
    
    var body: some View {
        Form {
            Section {
                SecureField(Localized.newMasterPassword, text: $state.password, prompt: nil)
                    .focused($focusedField, equals: .newMasterPassword)
                    .submitLabel(.next)
                    
                SecureField(Localized.repeatMasterPassword, text: $state.repeatedPassword, prompt: nil)
                    .focused($focusedField, equals: .repeatMasterPassword)
                    .submitLabel(.next)
            }
            .onSubmit {
                switch focusedField {
                case .newMasterPassword:
                    focusedField = .repeatMasterPassword
                case .repeatMasterPassword:
                    focusedField = .newMasterPassword
                case .none:
                    focusedField = nil
                }
            }
            
            Section {
                Button(Localized.changeMasterPassword, role: .destructive) {
                    Task {
                        await state.changeMasterPassword()
                    }
                }
                .disabled(state.isButtonDisabled)
            } footer: {
                if state.isLoadingVisible {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(Localized.changeMasterPassword)
        .disabled(state.isInputDisabled)
        .onAppear {
            focusedField = .newMasterPassword
        }
    }
    
}

extension MasterPasswordSettingsView {
    
    enum Field {
        
        case newMasterPassword
        case repeatMasterPassword
        
    }
    
}
