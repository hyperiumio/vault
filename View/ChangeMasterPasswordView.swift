import Localization
import SwiftUI

#if os(macOS)
struct ChangeMasterPasswordView<Model>: View where Model: ChangeMasterPasswordModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "key.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            VStack {
                SecureField(LocalizedString.currentMasterPassword, text: $model.currentPassword)
                    .disabled(model.textInputDisabled)
                
                SecureField(LocalizedString.newMasterPassword, text: $model.newPassword)
                    .disabled(model.textInputDisabled)
                
                SecureField(LocalizedString.repeatNewPassword, text: $model.repeatedNewPassword)
                    .disabled(model.textInputDisabled)
            }
            
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .invalidCurrentPassword:
                ErrorBadge(LocalizedString.invalidCurrentPassword)
            case .newPasswordMismatch:
                ErrorBadge(LocalizedString.passwordMismatch)
            case .insecureNewPassword:
                ErrorBadge(LocalizedString.insecurePassword)
            case .masterPasswordChangeDidFail:
                ErrorBadge(LocalizedString.masterPasswordChangeDidFail)
            }
            
            HStack {
                Spacer()
                
                Button(LocalizedString.cancel, action: model.cancel)
                    .keyboardShortcut(.cancelAction)
                
                Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .frame(width: 300)
        .padding()
    }

}
#endif

#if os(iOS)
struct ChangeMasterPasswordView<Model>: View where Model: ChangeMasterPasswordModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: headerImage) {
                    SecureField(LocalizedString.currentMasterPassword, text: $model.currentPassword)
                        .disabled(model.textInputDisabled)
                    
                    SecureField(LocalizedString.newMasterPassword, text: $model.newPassword)
                        .disabled(model.textInputDisabled)
                    
                    SecureField(LocalizedString.repeatNewPassword, text: $model.repeatedNewPassword)
                        .disabled(model.textInputDisabled)
                }
                
                Section(footer: errorMessage) {
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(LocalizedString.masterPassword, displayMode: .inline)
            .navigationBarItems(trailing: cancelButton)
        }
    }
    
    private var headerImage: some View {
        HStack {
            Spacer()
            
            Image(systemName: "key.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            Spacer()
        }
    }
    
    private var errorMessage: some View {
        HStack {
            Spacer()
            
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .invalidCurrentPassword:
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
    
    private var cancelButton: some View {
        Button(LocalizedString.cancel, action: model.cancel)
    }
    
}
#endif

#if DEBUG
class ChangeMasterPasswordModelStub: ChangeMasterPasswordModelRepresentable {
    
    var currentPassword = ""
    var newPassword = ""
    var repeatedNewPassword = ""
    var textInputDisabled = false
    var status = ChangeMasterPasswordModel.Status.masterPasswordChangeDidFail
    
    func cancel() {}
    func changeMasterPassword() {}
    
}

struct ChangeMasterPasswordPreview: PreviewProvider {
    
    static var previews: some View {
        ChangeMasterPasswordView(model: ChangeMasterPasswordModelStub())
            .preferredColorScheme(.dark)
    }
    
}
#endif
