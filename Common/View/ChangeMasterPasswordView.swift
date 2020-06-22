import SwiftUI

struct ChangeMasterPasswordView: View {
    
    @ObservedObject var model: ChangeMasterPasswordModel
    
    var body: some View {
        return VStack {
            SecureField(.currentMasterPassword, text: $model.currentPassword)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            SecureField(.newMasterPassword, text: $model.newPassword)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            SecureField(.repeatNewPassword, text: $model.repeatedNewPassword)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            HStack {
                Button(.cancel, action: model.cancel)
                
                Button(.createVault, action: model.changeMasterPassword)
                .disabled(model.createMasterKeyButtonDisabled)
            }.padding()
            
            model.message.map { message in
                return Text(message.key)
            }
            
            ActivityIndicator(isAnimating: model.isLoading)
        }
    }
    
}

extension ChangeMasterPasswordModel.Message {
    
    var key: LocalizedStringKey {
        switch self {
        case .invalidCurrentPassword:
            return .invalidCurrentPassword
        case .newPasswordMismatch:
            return .passwordMismatch
        case .masterPasswordChangeDidFail:
            return .masterPasswordChangeDidFail
        }
    }
    
}
