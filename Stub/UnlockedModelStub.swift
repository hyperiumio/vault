#if DEBUG
import Combine
import Foundation

class UnlockedModelStub: UnlockedModelRepresentable {
    
    typealias SettingsModel = SettingsModelStub
    typealias VaultItemCreationModel = VaultItemCreationModelStub
    typealias VaultItemReferenceModel = VaultItemReferenceModelStub
    
    @Published var searchText = ""
    @Published var creationModel: VaultItemCreationModelStub?
    @Published var failure: UnlockedFailure?
    
    let itemCollation: Collation
    let settingsModel: SettingsModelStub
    
    var lock: AnyPublisher<URL, Never> {
        lockSubject.eraseToAnyPublisher()
    }
    
    func reload() {}
    func createVaultItem() {}
    func lockApp() {}
    
    init(itemCollation: Collation, settingsModel: SettingsModelStub, creationModel: VaultItemCreationModelStub?, failure: UnlockedFailure?) {
        self.itemCollation = itemCollation
        self.settingsModel = settingsModel
        self.creationModel = creationModel
        self.failure = failure
    }
    
    let lockSubject = PassthroughSubject<URL, Never>()
    
}
#endif
