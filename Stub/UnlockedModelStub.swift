#if DEBUG
import Combine
import Foundation
import UniformTypeIdentifiers

class UnlockedModelStub: UnlockedModelRepresentable {
    
    typealias SettingsModel = SettingsModelStub
    typealias VaultItemModel = VaultItemModelStub
    typealias VaultItemReferenceModel = VaultItemReferenceModelStub
    
    @Published var searchText = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    let itemCollation: Collation?
    let settingsModel: SettingsModelStub
    
    var lockRequest: AnyPublisher<Bool, Never> {
        lockRequestSubject.eraseToAnyPublisher()
    }
    
    var storeDirectory: URL {
        URL(fileURLWithPath: "")
    }
    
    func reload() {}
    func createLoginItem() {}
    func createPasswordItem() {}
    func createWifiItem() {}
    func createNoteItem() {}
    func createBankCardItem() {}
    func createBankAccountItem() {}
    func createCustomItem() {}
    func createFileItem(data: Data, type: UTType) {}
    func lockApp(enableBiometricUnlock: Bool) {}
    
    init(itemCollation: Collation, settingsModel: SettingsModelStub, creationModel: VaultItemModel?, failure: UnlockedFailure?) {
        self.itemCollation = itemCollation
        self.settingsModel = settingsModel
        self.creationModel = creationModel
        self.failure = failure
    }
    
    let lockRequestSubject = PassthroughSubject<Bool, Never>()
    
}
#endif
