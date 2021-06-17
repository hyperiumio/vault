import Combine
import Crypto
import Foundation
import Model

@MainActor
protocol VaultItemStateRepresentable: ObservableObject, Identifiable, Equatable {
    
    associatedtype LoginState: LoginStateRepresentable
    associatedtype PasswordState: PasswordStateRepresentable
    associatedtype FileState: FileStateRepresentable
    associatedtype NoteState: NoteStateRepresentable
    associatedtype BankCardState: BankCardStateRepresentable
    associatedtype WifiState: WifiStateRepresentable
    associatedtype BankAccountState: BankAccountStateRepresentable
    associatedtype CustomState: CustomStateRepresentable
    
    typealias Element = VaultItemElement<LoginState, PasswordState, FileState, NoteState, BankCardState, WifiState, BankAccountState, CustomState>
    
    var title: String { get set }
    var primaryItemState: Element { get }
    var secondaryItemStates: [Element] { get }
    var created: Date? { get }
    var modified: Date? { get }
    
    func addSecondaryItem(with type: SecureItemType)
    func deleteSecondaryItem(at index: Int)
    func discardChanges()
    func save() async
    func delete() async
    
}

@MainActor
protocol VaultItemStateDependency {
    
    associatedtype LoginState: LoginStateRepresentable
    associatedtype PasswordState: PasswordStateRepresentable
    associatedtype FileState: FileStateRepresentable
    associatedtype NoteState: NoteStateRepresentable
    associatedtype BankCardState: BankCardStateRepresentable
    associatedtype WifiState: WifiStateRepresentable
    associatedtype BankAccountState: BankAccountStateRepresentable
    associatedtype CustomItemState: CustomStateRepresentable
    
    func loginState(item: LoginItem) -> LoginState
    func passwordState(item: PasswordItem) -> PasswordState
    func fileState(item: FileItem) -> FileState
    func noteState(item: NoteItem) -> NoteState
    func bankCardState(item: BankCardItem) -> BankCardState
    func wifiState(item: WifiItem) -> WifiState
    func bankAccountState(item: BankAccountItem) -> BankAccountState
    func customItemState(item: CustomItem) -> CustomItemState
    
}

@MainActor
class VaultItemState<Dependency: VaultItemStateDependency>: VaultItemStateRepresentable {
    
    typealias LoginState = Dependency.LoginState
    typealias PasswordState = Dependency.PasswordState
    typealias FileState = Dependency.FileState
    typealias NoteState = Dependency.NoteState
    typealias BankCardState = Dependency.BankCardState
    typealias WifiState = Dependency.WifiState
    typealias BankAccountState = Dependency.BankAccountState
    typealias CustomState = Dependency.CustomItemState
    
    @Published var title = ""
    @Published var primaryItemState: Element
    @Published var secondaryItemStates: [Element]
    
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
        self.primaryItemState = dependency.vaultItemElement(from: storeItem.primaryItem)
        self.secondaryItemStates = storeItem.secondaryItems.map(dependency.vaultItemElement)
         */
        fatalError()
    }
    
    init(secureItem: SecureItem, store: Store, masterKey: MasterKey, dependency: Dependency) {
        self.originalStoreItem = nil
        self.originalItemLocator = nil
        self.store = store
        self.masterKey = masterKey
        self.dependency = dependency
        self.primaryItemState = dependency.vaultItemElement(from: secureItem)
        self.secondaryItemStates = []
    }
    
    func addSecondaryItem(with type: SecureItemType) {
        
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItemStates.remove(at: index)
    }
    
    func discardChanges() {
        guard let originalVaultItem = originalStoreItem else { return }
        
        title = originalVaultItem.name
        primaryItemState = dependency.vaultItemElement(from: originalVaultItem.primaryItem)
      //  secondaryItemStates = originalVaultItem.secondaryItems.map(dependency.vaultItemElement)
    }
    
    func save() async {

    }
    
    func delete() async {

    }
    
    nonisolated static func == (lhs: VaultItemState<Dependency>, rhs: VaultItemState<Dependency>) -> Bool {
        lhs === rhs
    }
    
}

@MainActor
enum VaultItemElement<LoginState: LoginStateRepresentable, PasswordState: PasswordStateRepresentable, FileState: FileStateRepresentable, NoteState: NoteStateRepresentable, BankCardState: BankCardStateRepresentable, WifiState: WifiStateRepresentable, BankAccountState: BankAccountStateRepresentable, CustomItemState: CustomStateRepresentable>: Identifiable {
    
    case login(LoginState)
    case password(PasswordState)
    case file(FileState)
    case note(NoteState)
    case bankCard(BankCardState)
    case wifi(WifiState)
    case bankAccount(BankAccountState)
    case custom(CustomItemState)
    
    nonisolated var id: ObjectIdentifier {
        switch self {
        case .login(let state):
            return state.id
        case .password(let state):
            return state.id
        case .file(let state):
            return state.id
        case .note(let state):
            return state.id
        case .bankCard(let state):
            return state.id
        case .wifi(let state):
            return state.id
        case .bankAccount(let state):
            return state.id
        case .custom(let state):
            return state.id
        }
    }
    
    var secureItem: SecureItem {
        switch self {
        case .login(let state):
            return SecureItem.login(state.item)
        case .password(let state):
            return SecureItem.password(state.item)
        case .file(let state):
            return SecureItem.file(state.item)
        case .note(let state):
            return SecureItem.note(state.item)
        case .bankCard(let state):
            return SecureItem.bankCard(state.item)
        case .wifi(let state):
            return SecureItem.wifi(state.item)
        case .bankAccount(let state):
            return SecureItem.bankAccount(state.item)
        case .custom(let state):
            return SecureItem.custom(state.item)
        }
    }
    
}

private extension VaultItemStateDependency {
    
    func vaultItemElement(from secureItem: SecureItem) -> VaultItemElement<LoginState, PasswordState, FileState, NoteState, BankCardState, WifiState, BankAccountState, CustomItemState> {
        switch secureItem {
        case .password(let item):
            let state = passwordState(item: item)
            return .password(state)
        case .login(let item):
            let state = loginState(item: item)
            return .login(state)
        case .file(let item):
            let state = fileState(item: item)
            return .file(state)
        case .note(let item):
            let state = noteState(item: item)
            return .note(state)
        case .bankCard(let item):
            let state = bankCardState(item: item)
            return .bankCard(state)
        case .wifi(let item):
            let state = wifiState(item: item)
            return .wifi(state)
        case .bankAccount(let item):
            let state = bankAccountState(item: item)
            return .bankAccount(state)
        case .custom(let item):
            let state = customItemState(item: item)
            return .custom(state)
        }
    }
    
}

#if DEBUG
class VaultItemStateStub: VaultItemStateRepresentable {
    
    typealias LoginState = LoginStateStub
    typealias PasswordState = PasswordStateStub
    typealias FileState = FileStateStub
    typealias NoteState = NoteStateStub
    typealias BankCardState = BankCardStateStub
    typealias WifiState = WifiStateStub
    typealias BankAccountState = BankAccountStateStub
    typealias CustomState = CustomStateStub
    
    @Published var title = ""
    @Published var created = Date() as Date?
    @Published var modified = Date() as Date?
    @Published var primaryItemState: Element
    @Published var secondaryItemStates: [Element]
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func addSecondaryItem(with type: SecureItemType) {}
    func deleteSecondaryItem(at index: Int) {}
    func discardChanges() {}
    func save() {}
    func delete() {}
    
    init(primaryItemState: Element, secondaryItemStates: [Element]) {
        self.primaryItemState = primaryItemState
        self.secondaryItemStates = secondaryItemStates
    }
    
    nonisolated static func == (lhs: VaultItemStateStub, rhs: VaultItemStateStub) -> Bool {
        lhs === rhs
    }
    
}
#endif
