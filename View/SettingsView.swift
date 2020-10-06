import Localization
import SwiftUI

#if os(macOS)
struct SettingsView<Model>: View where Model: SettingsModelRepresentable {
    
    var body: some View {
        Text("Settings")
    }
    
    init(_ model: Model) {}
    
}
#endif

#if os(iOS)
struct SettingsView<Model: SettingsModelRepresentable>: View {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    var isBiometricsEnabledBinding: Binding<Bool> {
        Binding {
            model.isBiometricUnlockEnabled
        } set: { isEnabled in
            model.setBiometricUnlock(isEnabled: isEnabled)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                switch model.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .touchID:
                    Section {
                        Toggle(LocalizedString.useTouchID, isOn: isBiometricsEnabledBinding)
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model)
                            }
                    } footer: {
                        Text(LocalizedString.touchIDDescription)
                    }
                case .faceID:
                    Section {
                        Toggle(LocalizedString.useFaceID, isOn: isBiometricsEnabledBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model)
                            }
                    } footer: {
                        Text(LocalizedString.faceIDDescription)
                    }
                }
                
                Section {
                    Button(LocalizedString.changeMasterPassword, action: model.changeMasterPassword)
                        .sheet(item: $model.changeMasterPasswordModel) { model in
                            ChangeMasterPasswordView(model)
                        }
                } footer: {
                    Text(LocalizedString.changeMasterPasswordDescription)
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
    
    init(_ model: Model) {
        self.model = model
    }
    
}
#endif
