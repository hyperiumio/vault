import SwiftUI

struct ChangeMasterPasswordView<ChangeMasterPasswordState>: View where ChangeMasterPasswordState: ChangeMasterPasswordStateRepresentable {
    
    @ObservedObject private var state: ChangeMasterPasswordState
    @FocusState private var focusedField: Field?
    
    init(_ state: ChangeMasterPasswordState) {
        self.state = state
    }
    
    var body: some View {
        List {
            Section {
                SecureField(.newMasterPassword, text: $state.password, prompt: nil)
                    .focused($focusedField, equals: .newMasterPassword)
                    .submitLabel(.next)
                    
                SecureField(.repeatMasterPassword, text: $state.repeatedPassword, prompt: nil)
                    .focused($focusedField, equals: .repeatMasterPassword)
                    .submitLabel(.next)
            }
            .onAppear {
                focusedField = .newMasterPassword
            }
            .onSubmit {
                switch focusedField {
                case .newMasterPassword:
                    focusedField = .repeatMasterPassword
                case .repeatMasterPassword:
                    focusedField = .newMasterPassword
                case nil:
                    focusedField = nil
                }
            }
            Section {
                Button(.changeMasterPassword, role: .destructive) {
                    focusedField = nil
                    await state.changeMasterPassword()
                }
                .disabled(state.password.isEmpty || state.repeatedPassword.isEmpty)
            }
        }
        .disabled(state.state == .changingPassword)
        #if os(iOS)
        .navigationBarTitle(.masterPassword, displayMode: .inline)
        .listStyle(.grouped)
        #endif
    }
    
}

extension ChangeMasterPasswordView {
    
    enum Field {
        
        case newMasterPassword
        case repeatMasterPassword
        
    }
    
}

#if DEBUG
struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static let state = ChangeMasterPasswordStateStub()
    
    static var previews: some View {
        NavigationView {
            ChangeMasterPasswordView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
