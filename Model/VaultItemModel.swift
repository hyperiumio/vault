import Combine
import Crypto
import Foundation
import Store

protocol VaultItemModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype LoginModel: LoginModelRepresentable
    associatedtype PasswordModel: PasswordModelRepresentable
    associatedtype FileModel: FileModelRepresentable
    associatedtype NoteModel: NoteModelRepresentable
    associatedtype BankCardModel: BankCardModelRepresentable
    associatedtype WifiModel: WifiModelRepresentable
    associatedtype BankAccountModel: BankAccountModelRepresentable
    associatedtype CustomItemModel: CustomItemModelRepresentable
    
    typealias Element = VaultItemElement<LoginModel, PasswordModel, FileModel, NoteModel, BankCardModel, WifiModel, BankAccountModel, CustomItemModel>
    
    var name: String { get set }
    var status: VaultItemStatus { get }
    var primaryItemModel: Element { get }
    var secondaryItemModels: [Element] { get }
    var created: Date? { get }
    var modified: Date? { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func addSecondaryItem(with typeIdentifier: SecureItemTypeIdentifier)
    func deleteSecondaryItem(at index: Int)
    func save()
    
}

protocol VaultItemModelDependency {
    
    associatedtype LoginModel: LoginModelRepresentable
    associatedtype PasswordModel: PasswordModelRepresentable
    associatedtype FileModel: FileModelRepresentable
    associatedtype NoteModel: NoteModelRepresentable
    associatedtype BankCardModel: BankCardModelRepresentable
    associatedtype WifiModel: WifiModelRepresentable
    associatedtype BankAccountModel: BankAccountModelRepresentable
    associatedtype CustomItemModel: CustomItemModelRepresentable
    
    func loginModel(item: LoginItem) -> LoginModel
    func passwordModel(item: PasswordItem) -> PasswordModel
    func fileModel(item: FileItem) -> FileModel
    func noteModel(item: NoteItem) -> NoteModel
    func bankCardModel(item: BankCardItem) -> BankCardModel
    func wifiModel(item: WifiItem) -> WifiModel
    func bankAccountModel(item: BankAccountItem) -> BankAccountModel
    func customItemModel(item: CustomItem) -> CustomItemModel
    
    func loginModel() -> LoginModel
    func passwordModel() -> PasswordModel
    func fileModel() -> FileModel
    func noteModel() -> NoteModel
    func bankCardModel() -> BankCardModel
    func wifiModel() -> WifiModel
    func bankAccountModel() -> BankAccountModel
    func customItemModel() -> CustomItemModel
    
}

enum VaultItemStatus {
    
    case none
    case saving
    case saveOperationFailed
    
}

enum VaultItemElement<LoginModel: LoginModelRepresentable, PasswordModel: PasswordModelRepresentable, FileModel: FileModelRepresentable, NoteModel: NoteModelRepresentable, BankCardModel: BankCardModelRepresentable, WifiModel: WifiModelRepresentable, BankAccountModel: BankAccountModelRepresentable, CustomItemModel: CustomItemModelRepresentable>: Identifiable {
    
    case login(LoginModel)
    case password(PasswordModel)
    case file(FileModel)
    case note(NoteModel)
    case bankCard(BankCardModel)
    case wifi(WifiModel)
    case bankAccount(BankAccountModel)
    case custom(CustomItemModel)
    
    var id: ObjectIdentifier {
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
            return SecureItem.login(model.loginItem)
        case .password(let model):
            return SecureItem.password(model.passwordItem)
        case .file(let model):
            return SecureItem.file(model.fileItem)
        case .note(let model):
            return SecureItem.note(model.noteItem)
        case .bankCard(let model):
            return SecureItem.bankCard(model.bankCardItem)
        case .wifi(let model):
            return SecureItem.wifi(model.wifiItem)
        case .bankAccount(let model):
            return SecureItem.bankAccount(model.bankAccountItem)
        case .custom(let model):
            return SecureItem.custom(model.customItem)
        }
    }
    
}

class VaultItemModel<Dependency: VaultItemModelDependency>: VaultItemModelRepresentable {
    
    typealias LoginModel = Dependency.LoginModel
    typealias PasswordModel = Dependency.PasswordModel
    typealias FileModel = Dependency.FileModel
    typealias NoteModel = Dependency.NoteModel
    typealias BankCardModel = Dependency.BankCardModel
    typealias WifiModel = Dependency.WifiModel
    typealias BankAccountModel = Dependency.BankAccountModel
    typealias CustomItemModel = Dependency.CustomItemModel
    
    @Published var name = ""
    @Published var status = VaultItemStatus.none
    @Published var primaryItemModel: Element
    @Published var secondaryItemModels: [Element]
    
    var created: Date? { originalVaultItem?.created }
    var modified: Date? { originalVaultItem?.modified }
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let store: VaultItemStore
    private let dependency: Dependency
    private let originalVaultItem: VaultItem?
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var addItemSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(store: VaultItemStore, vaultItem: VaultItem, dependency: Dependency) {
        
        self.store = store
        self.dependency = dependency
        self.originalVaultItem = vaultItem
        self.name = vaultItem.name
        self.primaryItemModel = dependency.vaultItemElement(from: vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(dependency.vaultItemElement)
    }
    
    init(store: VaultItemStore, typeIdentifier: SecureItemTypeIdentifier, dependency: Dependency) {
        self.store = store
        self.dependency = dependency
        self.originalVaultItem = nil
        self.primaryItemModel = dependency.vaultItemElement(with: typeIdentifier)
        self.secondaryItemModels = []
    }
    
    func addSecondaryItem(with typeIdentifier: SecureItemTypeIdentifier) {
        let model = dependency.vaultItemElement(with: typeIdentifier)
        secondaryItemModels.append(model)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItemModels.remove(at: index)
    }
    
    func save() {
        let now = Date()
        let id = originalVaultItem?.id ?? UUID()
        let primarySecureItem = primaryItemModel.secureItem
        let secondarySecureItems = secondaryItemModels.map(\.secureItem)
        let created = originalVaultItem?.created ?? now
        let modified = now
        let vaultItem = VaultItem(id: id, name: name, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: created, modified: modified)
        
        status = .saving
        saveSubscription = store.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .saveOperationFailed
                }
            } receiveValue: { [doneSubject] _ in
                doneSubject.send()
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
    
    func vaultItemElement(with typeIdentifier: SecureItemTypeIdentifier) -> VaultItemElement<LoginModel, PasswordModel, FileModel, NoteModel, BankCardModel, WifiModel, BankAccountModel, CustomItemModel> {
        switch typeIdentifier {
        case .login:
            let model = loginModel()
            return .login(model)
        case .password:
            let model = passwordModel()
            return .password(model)
        case .file:
            let model = fileModel()
            return .file(model)
        case .note:
            let model = noteModel()
            return .note(model)
        case .bankCard:
            let model = bankCardModel()
            return .bankCard(model)
        case .wifi:
            let model = wifiModel()
            return .wifi(model)
        case .bankAccount:
            let model = bankAccountModel()
            return .bankAccount(model)
        case .custom:
            let model = customItemModel()
            return .custom(model)
        }
    }
    
}