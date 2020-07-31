import Localization
import SwiftUI

struct SetupView: View {
    
    @ObservedObject var model: SetupModel
    
    var body: some View {
        VStack {            
            SecureField(LocalizedString.masterPassword, text: $model.password)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            SecureField(LocalizedString.repeatPassword, text: $model.repeatedPassword)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            Button(LocalizedString.createVault, action: model.createMasterKey)
                .disabled(model.createMasterKeyButtonDisabled)
            
            
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
    
}
