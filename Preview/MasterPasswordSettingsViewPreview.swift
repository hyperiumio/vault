#if DEBUG
import SwiftUI

struct MasterPasswordSettingsViewPreview: PreviewProvider {
    
    static let masterPasswordSettingsDependency = MasterPasswordSettingDependencyStub()
    static let masterPasswordSettingsState = MasterPasswordSettingsState(dependency: masterPasswordSettingsDependency)
    
    static var previews: some View {
        NavigationView {
            MasterPasswordSettingsView(masterPasswordSettingsState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            MasterPasswordSettingsView(masterPasswordSettingsState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
