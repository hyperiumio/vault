#if DEBUG
import SwiftUI
import Sort

struct UnlockViewPreview: PreviewProvider {
    
    static let model: UnlockedModelStub = {
        let itemCollation = AlphabeticCollation<VaultItemReferenceModelStub>(from: [])
        let settingsModel = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, biometricAvailablity: .notAvailable, isBiometricUnlockEnabled: false)
        let model = UnlockedModelStub(itemCollation: itemCollation, settingsModel: settingsModel, creationModel: nil, failure: nil)
        return model
    }()
    
    static var previews: some View {
        UnlockedView(model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
