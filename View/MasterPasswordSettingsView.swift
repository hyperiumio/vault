import SwiftUI

struct MasterPasswordSettingsView: View {
    
    @State var password = ""
    @State var repeatedPassword = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        List {
            Section {
                SecureField(.newMasterPassword, text: $password, prompt: nil)
                    .focused($focusedField, equals: .newMasterPassword)
                    .submitLabel(.next)
                    
                SecureField(.repeatMasterPassword, text: $repeatedPassword, prompt: nil)
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
                    // change master password
                }
                .disabled(password.isEmpty || repeatedPassword.isEmpty)
            }
        }
    }
    
}

extension MasterPasswordSettingsView {
    
    enum Field {
        
        case newMasterPassword
        case repeatMasterPassword
        
    }
    
}
