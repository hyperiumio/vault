import SwiftUI

struct SetupView: View {
    
    @ObservedObject var model: SetupModel
    
    var body: some View {
        return VStack {
            SecureField(.masterPassword, text: $model.password)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            SecureField(.repeatPassword, text: $model.repeatedPassword)
                .frame(width: 220)
                .disabled(model.textInputDisabled)
            
            Button(.createVault, action: model.createMasterKey)
                .disabled(model.createMasterKeyButtonDisabled)
            
            model.message.map { message in
                return Text(message.key)
            }
            
            ActivityIndicator(isAnimating: model.isLoading)
        }.frame(width: 500, height: 500)
    }
    
}

extension SetupModel.Message {
    
    var key: LocalizedStringKey {
        switch self {
        case .passwordMismatch:
            return .passwordMismatch
        case .vaultCreationFailed:
            return .vaultCreationFailed
        }
    }
    
}