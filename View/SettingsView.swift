import SwiftUI

struct SettingsView<S>: View where S: SettingsStateRepresentable {
    
    @ObservedObject private var state: S
    @Environment(\.presentationMode) private var presentationMode
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            List {
                switch state.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Section {
                        Toggle(.useTouchID, isOn: $state.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.touchIDDescription)
                    }
                case .enrolled(.faceID):
                    Section {
                        Toggle(.useFaceID, isOn: $state.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.faceIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(.changeMasterPassword, destination: ChangeMasterPasswordView(state.changeMasterPasswordState))
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
                switch state.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Toggle(.useTouchID, isOn: $state.isBiometricUnlockEnabled)
                case .enrolled(.faceID):
                    Toggle(.useFaceID, isOn: $state.isBiometricUnlockEnabled)
                }
                
                Divider()
                
                Button(.changeMasterPassword) {
                    
                }
            }
            .tabItem {
                Label(.security, systemImage: SFSymbolName.lock)
            }
            .padding()
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        
        
    }
    #endif
    
    init(_ state: S) {
        self.state = state
    }
    
}

private extension Section where Parent == EmptyView, Content: View, Footer: View {

    init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.init(footer: footer(), content: content)
    }
}
