import Localization
import SwiftUI

#if os(macOS)
struct SettingsView<Model>: View where Model: SettingsModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: lockVaultDescription) {
                    Button(LocalizedString.lockVault, action: model.lockVault)
                }
                
                switch model.biometricAvailablity {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .touchID:
                    Section(footer: touchIDDescription) {
                        Toggle(LocalizedString.useTouchID, isOn: isBiometricsEnabledBinding)
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model: model)
                            }
                    }
                case .faceID:
                    Section(footer: faceIDDescription) {
                        Toggle(LocalizedString.useFaceID, isOn: isBiometricsEnabledBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model: model)
                            }
                    }
                }
                
                Section(footer: changeMasterPasswordDescription) {
                    Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                        .sheet(item: $model.changeMasterPasswordModel) { model in
                            ChangeMasterPasswordView(model: model)
                        }
                }
            }
            //.listStyle(GroupedListStyle())
            .navigationTitle(LocalizedString.settings)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    var isBiometricsEnabledBinding: Binding<Bool> {
        Binding {
            model.isBiometricUnlockEnabled
        } set: { isEnabled in
            model.setBiometricUnlock(isEnabled: isEnabled)
        }
    }
    
    var lockVaultDescription: some View {
        Text(LocalizedString.lockVaultDescription)
    }
    
    var touchIDDescription: some View {
        Text(LocalizedString.touchIDDescription)
    }
    
    var faceIDDescription: some View {
        Text(LocalizedString.faceIDDescription)
    }
    
    var changeMasterPasswordDescription: some View {
        Text(LocalizedString.changeMasterPasswordDescription)
    }
    
}
#endif

#if os(iOS)
struct SettingsView<Model>: View where Model: SettingsModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: lockVaultDescription) {
                    Button(LocalizedString.lockVault, action: model.lockVault)
                }
                
                switch model.biometricAvailablity {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .touchID:
                    Section(footer: touchIDDescription) {
                        Toggle(LocalizedString.useTouchID, isOn: isBiometricsEnabledBinding)
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model: model)
                            }
                    }
                case .faceID:
                    Section(footer: faceIDDescription) {
                        Toggle(LocalizedString.useFaceID, isOn: isBiometricsEnabledBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model: model)
                            }
                    }
                }
                
                Section(footer: changeMasterPasswordDescription) {
                    Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                        .sheet(item: $model.changeMasterPasswordModel) { model in
                            ChangeMasterPasswordView(model: model)
                        }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(LocalizedString.settings)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    var isBiometricsEnabledBinding: Binding<Bool> {
        Binding {
            model.isBiometricUnlockEnabled
        } set: { isEnabled in
            model.setBiometricUnlock(isEnabled: isEnabled)
        }
    }
    
    var lockVaultDescription: some View {
        Text(LocalizedString.lockVaultDescription)
    }
    
    var touchIDDescription: some View {
        Text(LocalizedString.touchIDDescription)
    }
    
    var faceIDDescription: some View {
        Text(LocalizedString.faceIDDescription)
    }
    
    var changeMasterPasswordDescription: some View {
        Text(LocalizedString.changeMasterPasswordDescription)
    }
    
}
#endif

#if DEBUG
import Crypto

class SettingsUnlockedModelStub: SettingsModelRepresentable {
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    var changeMasterPasswordModel: ChangeMasterPasswordModel?
    var biometricAvailablity: BiometricKeychain.Availablity = .faceID
    var isBiometricUnlockEnabled = false
    
    func lockVault() {}
    func setBiometricUnlock(isEnabled: Bool) {}
    func changeMasterPassword() {}
    
}

struct SettingsUnlockedViewPreview: PreviewProvider {
    
    static var previews: some View {
        SettingsView(model: SettingsUnlockedModelStub())
    }
    
}
#endif
