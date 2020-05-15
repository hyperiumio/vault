import SwiftUI

struct PreferencesLoadedView: View {
    
    @ObservedObject var model: PreferencesLoadedModel
    
    var body: some View {
        let isBiometricUnlockEnabledBinding = Binding(get: model.getIsBiometricUnlockEnabled, set: model.setIsBiometricUnlockEnabled)
        
        return VStack {
            Button(.changeMasterPassword, action: model.changeMasterPassword)
            Toggle(.useBiometricUnlock, isOn: isBiometricUnlockEnabledBinding)
                .disabled(!model.supportsBiometricUnlock)
                .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                    return BiometricUnlockPreferencesView(model: model)
                }
        }
    }
    
}
