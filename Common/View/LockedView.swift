import SwiftUI

struct LockedView: View {
    
    @ObservedObject var model: LockedModel
    
    var body: some View {
        return VStack {
            SecureField(.enterPassword, text: $model.password, onCommit: model.masterPasswordLogin)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            Button(.unlockVault, action: model.masterPasswordLogin)
                .disabled(model.decryptMasterKeyButtonDisabled)
            
            model.biometricUnlockMethod.map { method in
                return BiometricUnlock(method: method, unlock: model.biometricLogin)
            }
            
            model.message.map { message in
                Text(message.key)
            }
            
            ActivityIndicator(isAnimating: model.isLoading)
        }.frame(width: 500, height: 500)
    }
    
}

extension LockedModel.Message {
    
    var key: LocalizedStringKey {
        switch self {
        case .invalidPassword:
            return .wrongPassword
        }
    }
    
}
