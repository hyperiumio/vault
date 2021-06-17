import SwiftUI

struct ChangeMasterPasswordView<S>: View where S: ChangeMasterPasswordStateRepresentable {
    
    @ObservedObject private var state: S
    @FocusState private var focusedField: Field?
    
    init(_ state: S) {
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
        .navigationBarTitle(.masterPassword, displayMode: .inline)
        .listStyle(.grouped)
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
