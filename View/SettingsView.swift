import Localization
import SwiftUI

#if os(iOS)
struct SettingsView<Model: SettingsModelRepresentable>: View {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                switch model.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Section {
                        Toggle(LocalizedString.useTouchID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(LocalizedString.touchIDDescription)
                    }
                case .enrolled(.faceID):
                    Section {
                        Toggle(LocalizedString.useFaceID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(LocalizedString.faceIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(LocalizedString.changeMasterPassword, destination: ChangeMasterPasswordView(model.changeMasterPasswordModel))
                } footer: {
                    Text(LocalizedString.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
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
