import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var state: SettingsState
    
    init(_ state: SettingsState) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            List {
                if let biometrySettingsState = state.biometrySettingsState {
                    BiometrySettingsView(biometrySettingsState)
                }
                
                Section {
                    NavigationLink(.changeMasterPassword) {
                        MasterPasswordSettingsView(state.masterPasswordSettingsState)
                    }
                } footer: {
                    Text(.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .navigationTitle(.settings)
        }
        .task {
            await state.load()
        }
    }
    
}
