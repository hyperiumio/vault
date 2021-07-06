#if DEBUG
import SwiftUI
#warning("Todo")
struct SettingsViewPreview: PreviewProvider {
    
    static let settingsDependency = SettingsDependencyStub()
    static let settingsState = SettingsState(dependency: settingsDependency)
    
    static var previews: some View {
        SettingsView(settingsState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SettingsView(settingsState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif

