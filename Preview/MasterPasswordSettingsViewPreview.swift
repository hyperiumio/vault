#if DEBUG
import SwiftUI

struct MasterPasswordSettingsViewPreview: PreviewProvider {
    
    static let masterPasswordSettingsDependency = MasterPasswordSettingsServiceStub()
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

extension MasterPasswordSettingsViewPreview {
    
    struct MasterPasswordSettingsServiceStub: MasterPasswordSettingsDependency {
        
        func changeMasterPassword(from oldMasterPassword: String, to newMasterPassword: String) async throws {}
        
    }
    
}
#endif
