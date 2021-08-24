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
                SecureField(.newMasterPassword, text: $state.password, prompt: nil)
                    .focused($focusedField, equals: .newMasterPassword)
                    .submitLabel(.next)
                    
                SecureField(.repeatMasterPasswordTitle, text: $state.repeatedPassword, prompt: nil)
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
                Button(.changeMasterPassword, role: .destructive) {
                    state.changeMasterPassword()
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
        .navigationTitle(.changeMasterPassword)
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

#if DEBUG
struct MasterPasswordSettingsViewPreview: PreviewProvider {
    
    static let state = MasterPasswordSettingsState(service: .stub)
    
    static var previews: some View {
        NavigationView {
            MasterPasswordSettingsView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            MasterPasswordSettingsView(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
