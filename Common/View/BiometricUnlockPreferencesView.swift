import SwiftUI

struct BiometricUnlockPreferencesView: View {
    
    @ObservedObject var model: BiometricUnlockPreferencesModel
    
    var body: some View {
        return VStack {
            Text(.enableBiometricUnlockDescription)
                .padding()
            
            SecureField(.masterPassword, text: $model.password)
                .padding()
            
            ActivityIndicator(isAnimating: model.isLoading)
                .padding()
            
            model.message.map { message in
                return Text(message.key)
                    .padding()
            }
            
            HStack {
                Button(.cancel, action: model.cancel)
                Button(.enable, action: model.enabledBiometricUnlock)
            }.padding()
        }
    }
    
}

extension BiometricUnlockPreferencesModel.Message {
    
    var key: LocalizedStringKey {
        switch self {
        case .biometricActivationFailed:
            return .biometricActivationFailed
        case .invalidPassword:
            return .wrongPassword
        }
    }
    
}
