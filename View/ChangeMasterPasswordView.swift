import SwiftUI

struct ChangeMasterPasswordView<Model>: View where Model: ChangeMasterPasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    @FocusState private var focusedField: Field?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            Section {
                SecureField(.newMasterPassword, text: $model.password, prompt: nil)
                    .focused($focusedField, equals: .newMasterPassword)
                    .submitLabel(.next)
                    
                SecureField(.repeatMasterPassword, text: $model.repeatedPassword, prompt: nil)
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
                    await model.changeMasterPassword()
                }
                .disabled(model.password.isEmpty || model.repeatedPassword.isEmpty)
            }
        }
        .disabled(model.state == .changingPassword)
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
    
    static let model = ChangeMasterPasswordModelStub()
    
    static var previews: some View {
        NavigationView {
            ChangeMasterPasswordView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
