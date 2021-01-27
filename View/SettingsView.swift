import SwiftUI

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
        TabView {
            VStack {
                switch model.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Toggle(.useTouchID, isOn: $model.isBiometricUnlockEnabled)
                case .enrolled(.faceID):
                    Toggle(.useFaceID, isOn: $model.isBiometricUnlockEnabled)
                }
                
                Divider()
                
                Button(.changeMasterPassword) {
                    
                }
            }
            .tabItem {
                Label(.security, systemImage: SFSymbolName.lockFill)
            }
            .padding()
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        
        
    }
    #endif
    
    init(_ model: Model) {
        self.model = model
    }
    
}

private extension Section where Parent == EmptyView, Content: View, Footer: View {

    init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.init(footer: footer(), content: content)
    }
}
