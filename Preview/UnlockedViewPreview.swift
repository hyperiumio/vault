#if DEBUG
import SwiftUI
import Store
import Sort

struct UnlockViewPreview: PreviewProvider {
    
    static let emptyVaultModel: UnlockedModelStub = {
        let itemCollation = AlphabeticCollation<VaultItemReferenceModelStub>(from: [])
        let settingsModel = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, biometricAvailablity: .notAvailable, isBiometricUnlockEnabled: false)
        let model = UnlockedModelStub(itemCollation: itemCollation, settingsModel: settingsModel, creationModel: nil, failure: nil)
        return model
    }()
    
    static let everyItemModel: UnlockedModelStub = {
        let items = [
            VaultItemInfo(id: UUID(), name: "Foo", description: "Bar", primaryTypeIdentifier: .login, secondaryTypeIdentifiers: [], created: Date(), modified: Date())
        ]
        .map { itemInfo in
            VaultItemReferenceModelStub(state: .none, info: itemInfo)
        }
        let itemCollation = AlphabeticCollation<VaultItemReferenceModelStub>(from: items)
        let settingsModel = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, biometricAvailablity: .notAvailable, isBiometricUnlockEnabled: false)
        let model = UnlockedModelStub(itemCollation: itemCollation, settingsModel: settingsModel, creationModel: nil, failure: nil)
        return model
    }()
    
    static var previews: some View {
        Group {
            UnlockedView(emptyVaultModel)
            
            UnlockedView(everyItemModel)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
