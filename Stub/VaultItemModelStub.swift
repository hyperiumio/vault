#if DEBUG
import Combine
import Foundation

class VaultItemModelStub: VaultItemModelRepresentable {
    
    typealias LoginModel = LoginModelStub
    typealias PasswordModel = PasswordModelStub
    typealias FileModel = FileModelStub
    typealias NoteModel = NoteModelStub
    typealias BankCardModel = BankCardModelStub
    typealias WifiModel = WifiModelStub
    typealias BankAccountModel = BankAccountModelStub
    typealias CustomItemModel = CustomItemModelStub
    
    @Published var name: String
    @Published var status: VaultItemStatus
    @Published var primaryItemModel: Element
    @Published var secondaryItemModels: [Element]
    @Published var created: Date?
    @Published var modified: Date?
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    func addSecondaryItem(with typeIdentifier: SecureItemTypeIdentifier) {}
    func deleteSecondaryItem(at index: Int) {}
    func discardChanges() {}
    func save() {}
    func delete() {}
    
    init(name: String, status: VaultItemStatus, primaryItemModel: Element, secondaryItemModels: [Element], created: Date?, modified: Date?) {
        self.name = name
        self.status = status
        self.primaryItemModel = primaryItemModel
        self.secondaryItemModels = secondaryItemModels
        self.created = created
        self.modified = modified
    }
    
    let doneSubject = PassthroughSubject<Void, Never>()
    
}
#endif
