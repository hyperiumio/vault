#if DEBUG
import SwiftUI
import Sort

struct UnlockViewPreview: PreviewProvider {
    
    static let model: UnlockedModelStub = {
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
            UnlockedView(model)
                .preferredColorScheme(.light)
            
            UnlockedView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
