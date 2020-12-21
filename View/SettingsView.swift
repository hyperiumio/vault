import SwiftUI

// TODO

struct SettingsView<Model: SettingsModelRepresentable>: View {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            List {
                switch model.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Section {
                        Toggle(.useTouchID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.touchIDDescription)
                    }
                case .enrolled(.faceID):
                    Section {
                        Toggle(.useFaceID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.faceIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(.changeMasterPassword, destination: ChangeMasterPasswordView(model.changeMasterPasswordModel))
                } footer: {
                    Text(.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .listStyle(GroupedListStyle())
            .navigationTitle(.settings)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        NavigationView {
            List {
                switch model.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Section {
                        Toggle(.useTouchID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.touchIDDescription)
                    }
                case .enrolled(.faceID):
                    Section {
                        Toggle(.useFaceID, isOn: $model.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.faceIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(.changeMasterPassword, destination: ChangeMasterPasswordView(model.changeMasterPasswordModel))
                } footer: {
                    Text(.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .navigationTitle(.settings)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    #endif
    
    init(_ model: Model) {
        self.model = model
    }
    
}
