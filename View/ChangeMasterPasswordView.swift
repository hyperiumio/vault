import Localization
import SwiftUI

struct ChangeMasterPasswordView<Model>: View where Model: ChangeMasterPasswordModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    #if os(macOS)
    var body: some View {
        VStack {
            Header()
            
            Group {
                SecureField(LocalizedString.currentMasterPassword, text: $model.currentPassword)
                
                SecureField(LocalizedString.newMasterPassword, text: $model.newPassword)
                
                SecureField(LocalizedString.repeatNewPassword, text: $model.repeatedNewPassword)
            }
            .frame(maxWidth: 300)
            
            HStack {
                Spacer()
                
                Button(LocalizedString.cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
            }
        }
        .disabled(model.status == .loading)
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            List {
                Section(header: Header()) {
                    SecureField(LocalizedString.currentMasterPassword, text: $model.currentPassword)
                    
                    SecureField(LocalizedString.newMasterPassword, text: $model.newPassword)
                    
                    SecureField(LocalizedString.repeatNewPassword, text: $model.repeatedNewPassword)
                }
                
                Section(footer: ErrorMessage(status: model.status)) {
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                        
                        Spacer()
                    }
                }
            }
            .disabled(model.status == .loading)
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedString.masterPassword)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    #endif
    
    init(_ model: Model) {
        self.model = model
    }
    
}

private extension ChangeMasterPasswordView {
    
    struct Header: View {
        
        var body: some View {
            HStack {
                Spacer()
                
                Image.masterPassword
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                Spacer()
            }
        }
        
    }
    
    struct ErrorMessage: View {
        
        let status: ChangeMasterPasswordStatus
        
        var body: some View {
            HStack {
                Spacer()
                
                switch status {
                case .none, .loading:
                    EmptyView()
                case .invalidPassword:
                    ErrorBadge(LocalizedString.invalidCurrentPassword)
                case .newPasswordMismatch:
                    ErrorBadge(LocalizedString.passwordMismatch)
                case .insecureNewPassword:
                    ErrorBadge(LocalizedString.insecurePassword)
                case .masterPasswordChangeDidFail:
                    ErrorBadge(LocalizedString.masterPasswordChangeDidFail)
                }
                
                Spacer()
            }
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        
    }
    
}

#if DEBUG
/*
struct ChangeMasterPasswordViewPreviews: PreviewProvider {
    
    static var model = ChangeMasterPasswordModelStub()
    
    static var previews: some View {
        ChangeMasterPasswordView(model)
    }
    
}
 */
#endif
