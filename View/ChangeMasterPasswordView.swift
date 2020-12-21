import SwiftUI

// TODO

struct ChangeMasterPasswordView<Model>: View where Model: ChangeMasterPasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: ChangeMasterPasswordError?
    @Environment(\.presentationMode) private var presentationMode
    
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        List {
            Section {
                SecureField(.newMasterPassword, text: $model.password)
                
                SecureField(.repeatMasterPassword, text: $model.repeatedPassword)
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button(.changeMasterPassword, action: model.changeMasterPassword)
                        .disabled(model.password.isEmpty || model.repeatedPassword.isEmpty)
                    
                    Spacer()
                }
            }
        }
        .disabled(model.isLoading)
        .navigationBarTitle(.masterPassword, displayMode: .inline)
        .listStyle(GroupedListStyle())
        .onReceive(model.error) { error in
            self.error = error
        }
        .onReceive(model.done) {
            presentationMode.wrappedValue.dismiss()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
        .onAppear(perform: model.reset)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            Section {
                SecureField(.newMasterPassword, text: $model.password)
                
                SecureField(.repeatMasterPassword, text: $model.repeatedPassword)
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button(.changeMasterPassword, action: model.changeMasterPassword)
                        .disabled(model.password.isEmpty || model.repeatedPassword.isEmpty)
                    
                    Spacer()
                }
            }
        }
        .disabled(model.isLoading)
        .onReceive(model.error) { error in
            self.error = error
        }
        .onReceive(model.done) {
            presentationMode.wrappedValue.dismiss()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
        .onAppear(perform: model.reset)
    }
    #endif
    
}

private extension ChangeMasterPasswordView {
    
    static func title(for error: ChangeMasterPasswordError) -> Text {
        switch error {
        case .passwordMismatch:
            return Text(.passwordMismatch)
        case .masterPasswordChangeDidFail:
            return Text(.masterPasswordChangeDidFail)
        }
    }
    
}

#if DEBUG
struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static let model = ChangeMasterPasswordModelStub()
    
    static var previews: some View {
        Group {
            ChangeMasterPasswordView(model)
                .preferredColorScheme(.light)
            
            ChangeMasterPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
