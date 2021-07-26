import Resource
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

#if DEBUG
struct MasterPasswordSettingsViewPreview: PreviewProvider {
    
    static let service = SettingsServiceStub()
    static let state = MasterPasswordSettingsState(dependency: service)
    
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
