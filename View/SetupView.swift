import Localization
import SwiftUI

struct SetupView<Model>: View where Model: SetupModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {            
            SecureField(LocalizedString.masterPassword, text: $model.password)
                .frame(width: 220)
                .disabled(textInputDisabled)
            
            SecureField(LocalizedString.repeatPassword, text: $model.repeatedPassword)
                .frame(width: 220)
                .disabled(textInputDisabled)
            
            Button(LocalizedString.createVault, action: model.createMasterKey)
                .disabled(createMasterKeyButtonDisabled)
            
            
            switch model.status {
            case .none:
                EmptyView()
            case .loading:
                ProgressView()
            case .passwordMismatch:
                Text(LocalizedString.passwordMismatch)
            case .insecurePassword:
                Text(LocalizedString.insecurePassword)
            case .vaultCreationFailed:
                Text(LocalizedString.vaultCreationFailed)
            }

        }
    }
    
    var textInputDisabled: Bool { model.status == .loading }
    
    var createMasterKeyButtonDisabled: Bool { model.password.isEmpty || model.repeatedPassword.isEmpty || model.password.count != model.repeatedPassword.count || model.status == .loading }
    
}
