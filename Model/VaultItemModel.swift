import Combine
import Crypto
import Foundation
import Persistence

@MainActor
protocol VaultItemModelRepresentable: ObservableObject, Identifiable, Equatable {
    
    associatedtype LoginModel: LoginModelRepresentable
    associatedtype PasswordModel: PasswordModelRepresentable
    associatedtype FileModel: FileModelRepresentable
    associatedtype NoteModel: NoteModelRepresentable
    associatedtype BankCardModel: BankCardModelRepresentable
    associatedtype WifiModel: WifiModelRepresentable
    associatedtype BankAccountModel: BankAccountModelRepresentable
    associatedtype CustomModel: CustomModelRepresentable
    
    typealias Element = VaultItemElement<LoginModel, PasswordModel, FileModel, NoteModel, BankCardModel, WifiModel, BankAccountModel, CustomModel>
    
    var title: String { get set }
    var primaryItemModel: Element { get }
    var secondaryItemModels: [Element] { get }
    var created: Date? { get }
    var modified: Date? { get }
    
    func addSecondaryItem(with type: SecureItemType)
    func deleteSecondaryItem(at index: Int)
    func discardChanges()
    func save()
    func delete()
    
}

@MainActor
protocol VaultItemModelDependency {
    
    associatedtype LoginModel: LoginModelRepresentable
    associatedtype PasswordModel: PasswordModelRepresentable
    associatedtype FileModel: FileModelRepresentable
    associatedtype NoteModel: NoteModelRepresentable
    associatedtype BankCardModel: BankCardModelRepresentable
    associatedtype WifiModel: WifiModelRepresentable
    associatedtype BankAccountModel: BankAccountModelRepresentable
    associatedtype CustomItemModel: CustomModelRepresentable
    
    func loginModel(item: LoginItem) -> LoginModel
    func passwordModel(item: PasswordItem) -> PasswordModel
    func fileModel(item: FileItem) -> FileModel
    func noteModel(item: NoteItem) -> NoteModel
    func bankCardModel(item: BankCardItem) -> BankCardModel
    func wifiModel(item: WifiItem) -> WifiModel
    func bankAccountModel(item: BankAccountItem) -> BankAccountModel
    func customItemModel(item: CustomItem) -> CustomItemModel
    
}

@MainActor
class VaultItemModel<Dependency: VaultItemModelDependency>: VaultItemModelRepresentable {
    
    typealias LoginModel = Dependency.LoginModel
    typealias PasswordModel = Dependency.PasswordModel
    typealias FileModel = Dependency.FileModel
    typealias NoteModel = Dependency.NoteModel
    typealias BankCardModel = Dependency.BankCardModel
    typealias WifiModel = Dependency.WifiModel
    typealias BankAccountModel = Dependency.BankAccountModel
    typealias CustomModel = Dependency.CustomItemModel
    
    @Published var title = ""
    @Published var primaryItemModel: Element
    @Published var secondaryItemModels: [Element]
    
    var created: Date? { originalStoreItem?.created }
    var modified: Date? { originalStoreItem?.modified }
    
    private let store: Store
    private let originalItemLocator: StoreItemLocator?
    private let originalStoreItem: StoreItem?
    private let masterKey: MasterKey
    private let dependency: Dependency
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var addItemSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    private var deleteSubscription: AnyCancellable?
    
    init(storeItem: StoreItem, itemLocator: StoreItemLocator, store: Store, masterKey: MasterKey, dependency: Dependency) {
        /*
        self.originalStoreItem = storeItem
        self.originalItemLocator = itemLocator
        self.store = store
        self.masterKey = masterKey
        self.dependency = dependency
        self.title = storeItem.name
        self.primaryItemModel = dependency.vaultItemElement(from: storeItem.primaryItem)
        self.secondaryItemModels = storeItem.secondaryItems.map(dependency.vaultItemElement)
         */
        fatalError()
    }
    
    init(secureItem: SecureItem, store: Store, masterKey: MasterKey, dependency: Dependency) {
        self.originalStoreItem = nil
        self.originalItemLocator = nil
        self.store = store
        self.masterKey = masterKey
        self.dependency = dependency
        self.primaryItemModel = dependency.vaultItemElement(from: secureItem)
        self.secondaryItemModels = []
    }
    
    func addSecondaryItem(with type: SecureItemType) {
        
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItemModels.remove(at: index)
    }
    
    func discardChanges() {
        guard let originalVaultItem = originalStoreItem else { return }
        
        title = originalVaultItem.name
        primaryItemModel = dependency.vaultItemElement(from: originalVaultItem.primaryItem)
      //  secondaryItemModels = originalVaultItem.secondaryItems.map(dependency.vaultItemElement)
    }
    
    func save() {

    }
    
    func delete() {

    }
    
    nonisolated static func == (lhs: VaultItemModel<Dependency>, rhs: VaultItemModel<Dependency>) -> Bool {
        lhs === rhs
    }
    
}

@MainActor
enum VaultItemElement<LoginModel: LoginModelRepresentable, PasswordModel: PasswordModelRepresentable, FileModel: FileModelRepresentable, NoteModel: NoteModelRepresentable, BankCardModel: BankCardModelRepresentable, WifiModel: WifiModelRepresentable, BankAccountModel: BankAccountModelRepresentable, CustomItemModel: CustomModelRepresentable>: Identifiable {
    
    case login(LoginModel)
    case password(PasswordModel)
    case file(FileModel)
    case note(NoteModel)
    case bankCard(BankCardModel)
    case wifi(WifiModel)
    case bankAccount(BankAccountModel)
    case custom(CustomItemModel)
    
    nonisolated var id: ObjectIdentifier {
        switch self {
        case .login(let model):
            return model.id
        case .password(let model):
            return model.id
        case .file(let model):
            return model.id
        case .note(let model):
            return model.id
        case .bankCard(let model):
            return model.id
        case .wifi(let model):
            return model.id
        case .bankAccount(let model):
            return model.id
        case .custom(let model):
            return model.id
        }
    }
    
    var secureItem: SecureItem {
        switch self {
        case .login(let model):
            return SecureItem.login(model.item)
        case .password(let model):
            return SecureItem.password(model.item)
        case .file(let model):
            return SecureItem.file(model.item)
        case .note(let model):
            return SecureItem.note(model.item)
        case .bankCard(let model):
            return SecureItem.bankCard(model.item)
        case .wifi(let model):
            return SecureItem.wifi(model.item)
        case .bankAccount(let model):
            return SecureItem.bankAccount(model.item)
        case .custom(let model):
            return SecureItem.custom(model.item)
        }
    }
    
}

private extension VaultItemModelDependency {
    
    func vaultItemElement(from secureItem: SecureItem) -> VaultItemElement<LoginModel, PasswordModel, FileModel, NoteModel, BankCardModel, WifiModel, BankAccountModel, CustomItemModel> {
        switch secureItem {
        case .password(let item):
            let model = passwordModel(item: item)
            return .password(model)
        case .login(let item):
            let model = loginModel(item: item)
            return .login(model)
        case .file(let item):
            let model = fileModel(item: item)
            return .file(model)
        case .note(let item):
            let model = noteModel(item: item)
            return .note(model)
        case .bankCard(let item):
            let model = bankCardModel(item: item)
            return .bankCard(model)
        case .wifi(let item):
            let model = wifiModel(item: item)
            return .wifi(model)
        case .bankAccount(let item):
            let model = bankAccountModel(item: item)
            return .bankAccount(model)
        case .custom(let item):
            let model = customItemModel(item: item)
            return .custom(model)
        }
    }
    
}

#if DEBUG
class VaultItemModelStub: VaultItemModelRepresentable {
    
    typealias LoginModel = LoginModelStub
    typealias PasswordModel = PasswordModelStub
    typealias FileModel = FileModelStub
    typealias NoteModel = NoteModelStub
    typealias BankCardModel = BankCardModelStub
    typealias WifiModel = WifiModelStub
    typealias BankAccountModel = BankAccountModelStub
    typealias CustomModel = CustomModelStub
    
    @Published var title = ""
    @Published var created = Date() as Date?
    @Published var modified = Date() as Date?
    @Published var primaryItemModel: Element
    @Published var secondaryItemModels: [Element]
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func addSecondaryItem(with type: SecureItemType) {}
    func deleteSecondaryItem(at index: Int) {}
    func discardChanges() {}
    func save() {}
    func delete() {}
    
    init(primaryItemModel: Element, secondaryItemModels: [Element]) {
        self.primaryItemModel = primaryItemModel
        self.secondaryItemModels = secondaryItemModels
    }
    
    nonisolated static func == (lhs: VaultItemModelStub, rhs: VaultItemModelStub) -> Bool {
        lhs === rhs
    }
    
}
#endif
