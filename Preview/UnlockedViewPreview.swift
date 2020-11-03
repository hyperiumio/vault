#if DEBUG
import SwiftUI
import Sort

struct UnlockViewPreview: PreviewProvider {
    
    static let model: UnlockedModelStub = {
        let items = [
            VaultItemInfo(id: UUID(), name: "Foo", description: "Bar", primaryType: .note, secondaryTypes: [], created: Date(), modified: Date()),
            VaultItemInfo(id: UUID(), name: "Foo", description: "", primaryType: .password, secondaryTypes: [], created: Date(), modified: Date())
        ]
        .map { itemInfo in
            VaultItemReferenceModelStub(state: .loading, info: itemInfo)
        }
        let itemCollation = AlphabeticCollation<VaultItemReferenceModelStub>(from: items)
        let settingsModel = SettingsModelStub(biometricUnlockPreferencesModel: nil, changeMasterPasswordModel: nil, keychainAvailability: .notAvailable, isBiometricUnlockEnabled: false)
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
