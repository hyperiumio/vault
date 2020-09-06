#if DEBUG
import Combine
import Foundation

class UnlockedModelStub: UnlockedModelRepresentable {
    
    typealias SettingsModel = SettingsModelStub
    typealias VaultItemModel = VaultItemModelStub
    typealias VaultItemReferenceModel = VaultItemReferenceModelStub
    
    @Published var searchText = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    let itemCollation: Collation
    let settingsModel: SettingsModelStub
    
    var lock: AnyPublisher<URL, Never> {
        lockSubject.eraseToAnyPublisher()
    }
    
    func reload() {}
    func createVaultItem(with typeIdentifier: SecureItemTypeIdentifier) {}
    func lockApp() {}
    
    init(itemCollation: Collation, settingsModel: SettingsModelStub, creationModel: VaultItemModel?, failure: UnlockedFailure?) {
        self.itemCollation = itemCollation
        self.settingsModel = settingsModel
        self.creationModel = creationModel
        self.failure = failure
    }
    
    let lockSubject = PassthroughSubject<URL, Never>()
    
}
#endif
