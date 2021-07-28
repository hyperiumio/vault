import Resource
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
                    NavigationLink(Localized.changeMasterPassword) {
                        MasterPasswordSettingsView(state.masterPasswordSettingsState)
                    }
                } footer: {
                    Text(Localized.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .navigationTitle(Localized.settings)
        }
        .task {
            await state.load()
        }
    }
    
}

#if DEBUG
struct SettingsViewPreview: PreviewProvider {
    
    static let state = SettingsState(dependency: .stub)
    
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
