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
            state.load()
        }
    }
    
}

#if DEBUG
struct SettingsViewPreview: PreviewProvider {
    
    static let state = SettingsState(service: .stub)
    
    static var previews: some View {
        SettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SettingsView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
