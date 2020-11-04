import Localization
import SwiftUI

// TODO: cleanup

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
                case .enrolled(let biometryType):
                    Section {
                        Toggle(LocalizedString.useTouchID, isOn: isBiometricsEnabledBinding)
                            .animation(.default)
                            .sheet(item: $model.biometricUnlockPreferencesModel) { model in
                                BiometricUnlockPreferencesView(model)
                            }
                    } footer: {
                        Text(LocalizedString.touchIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(LocalizedString.changeMasterPassword, destination: ChangeMasterPasswordView(model.changeMasterPasswordModel))
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
