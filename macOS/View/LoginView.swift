import SwiftUI

struct LoginView: View {
    
    @ObservedObject var model: LoginModel
    
    var body: some View {
        return VStack {
            SecureField(.enterPassword, text: $model.password, onCommit: model.login)
                .frame(width: 220)
                .disabled(model.userInputDisabled)
            
            Button(action: model.login) {
                return Text(.unlockVault)
            }.disabled(model.userInputDisabled)
            
            Text(model.message.key)
            
            ActivityIndicator(isAnimating: model.isLoading)
        }.frame(width: 500, height: 500)
    }
    
}

extension LoginModel.Message {
    
    var key: LocalizedStringKey {
        switch self {
        case .none:
            return ""
        case .invalidPassword:
            return .wrongPassword
        }
    }
    
    
}
