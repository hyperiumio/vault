import SwiftUI

struct PreferencesLoadedView: View {
    
    @ObservedObject var model: PreferencesLoadedModel
    
    var body: some View {
        
        return VStack {
            biometricSetting
            
            Button(.changeMasterPassword, action: model.changeMasterPassword)
                .sheet(item: $model.changeMasterPasswordModel) { model in
                    return ChangeMasterPasswordView(model: model)
                }
        }
    }
    
    var biometricSetting: some View {
        switch model.biometricAvailablity {
        case .notAvailable:
            return Text(.biometricNotAvailable).eraseToAnyView()
        case .notEnrolled:
            return Text(.biometricNotEnrolled).eraseToAnyView()
        case .notAccessible, .touchID, .faceID:
            let isBiometricUnlockEnabledBinding = Binding(get: model.getIsBiometricUnlockEnabled, set: model.setIsBiometricUnlockEnabled)
            return Toggle(.useBiometricUnlock, isOn: isBiometricUnlockEnabledBinding)
                .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                    return BiometricUnlockPreferencesView(model: model)
                }
                .eraseToAnyView()
        }
    }
    
}
