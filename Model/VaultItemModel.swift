import Combine
import Crypto
import Foundation
import Store

protocol VaultItemModelRepresentable: ObservableObject, Identifiable {
    
    typealias Status = VaultItemStatus
    typealias TypeIdentifier = SecureItem.TypeIdentifier
    
    var name: String { get set }
    var status: Status { get }
    var primaryItemModel: SecureItemModel { get }
    var secondaryItemModels: [SecureItemModel] { get }
    var created: Date? { get }
    var modified: Date? { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func addSecondaryItem(with typeIdentifier: TypeIdentifier)
    func deleteSecondaryItem(at index: Int)
    func save()
    
    init(vault: Vault, vaultItem: VaultItem)
    init(vault: Vault, typeIdentifier: TypeIdentifier)
}

enum VaultItemStatus {
    
    case none
    case saving
    case saveOperationFailed
    
}

class VaultItemModel: VaultItemModelRepresentable {
    
    @Published var name = ""
    @Published var status = VaultItemStatus.none
    @Published var primaryItemModel: SecureItemModel
    @Published var secondaryItemModels: [SecureItemModel]
    
    var created: Date? { originalVaultItem?.created }
    var modified: Date? { originalVaultItem?.modified }
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let vault: Vault
    private let originalVaultItem: VaultItem?
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var addItemSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    required init(vault: Vault, vaultItem: VaultItem) {
        self.vault = vault
        self.originalVaultItem = vaultItem
        self.name = vaultItem.name
        self.primaryItemModel = SecureItemModel(vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(SecureItemModel.init)
    }
    
    required init(vault: Vault, typeIdentifier: TypeIdentifier) {
        self.vault = vault
        self.originalVaultItem = nil
        self.primaryItemModel = SecureItemModel(typeIdentifier)
        self.secondaryItemModels = []
    }
    
    func addSecondaryItem(with typeIdentifier: TypeIdentifier) {
        let model = SecureItemModel(typeIdentifier)
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
        saveSubscription = vault.saveVaultItem(vaultItem)
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

enum SecureItemModel: Identifiable {
    
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
    
    var typeIdentifier: SecureItem.TypeIdentifier {
        switch self {
        case .login:
            return .login
        case .password:
            return .password
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
    init(_ itemType: SecureItem.TypeIdentifier) {
        switch itemType {
        case .login:
            let model = LoginModel()
            self = .login(model)
        case .password:
            let model = PasswordModel()
            self = .password(model)
        case .file:
            let model = FileModel()
            self = .file(model)
        case .note:
            let model = NoteModel()
            self = .note(model)
        case .bankCard:
            let model = BankCardModel()
            self = .bankCard(model)
        case .wifi:
            let model = WifiModel()
            self = .wifi(model)
        case .bankAccount:
            let model = BankAccountModel()
            self = .bankAccount(model)
        case .custom:
            let model = CustomItemModel()
            self = .custom(model)
        }
    }
    
    init(_ secureItem: SecureItem) {
        switch secureItem {
        case .password(let password):
            let model = PasswordModel(password)
            self = .password(model)
        case .login(let login):
            let model = LoginModel(login)
            self = .login(model)
        case .file(let file):
            let model = FileModel(file)
            self = .file(model)
        case .note(let note):
            let model = NoteModel(note)
            self = .note(model)
        case .bankCard(let bankCard):
            let model = BankCardModel(bankCard)
            self = .bankCard(model)
        case .wifi(let wifi):
            let model = WifiModel(wifi)
            self = .wifi(model)
        case .bankAccount(let bankAccount):
            let model = BankAccountModel(bankAccount)
            self = .bankAccount(model)
        case .custom(let custom):
            let model = CustomItemModel(custom)
            self = .custom(model)
        }
    }
    
}
