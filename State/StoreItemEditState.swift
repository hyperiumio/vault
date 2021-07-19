import Foundation
import Model

protocol StoreItemEditDependency {
    
    var passwordDependency: PasswordItemDependency { get}
    var loginDependency: LoginItemDependency { get }
    var wifiDependency: WifiItemDependency { get }
    
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
}

@MainActor
class StoreItemEditState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: Element
    @Published private(set) var secondaryItems: [Element]
    
    let dependency: StoreItemEditDependency
    let editedStoreItem: StoreItem
    
    init(dependency: StoreItemEditDependency, editing storeItem: StoreItem) {
        self.dependency = dependency
        self.editedStoreItem = storeItem
        self.title = storeItem.name
        self.primaryItem = element(from: storeItem.primaryItem)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            element(from: item)
        }
        
        @MainActor
        func element(from secureItem: SecureItem) -> Element {
            switch secureItem {
            case .password(let item):
                let state = PasswordItemState(item, dependency: dependency.passwordDependency)
                return .password(state)
            case .login(let item):
                let state = LoginItemState(item, dependency: dependency.loginDependency)
                return .login(state)
            case .file(let item):
                let state = FileItemState(item)
                return .file(state)
            case .note(let item):
                let state = NoteItemState(item)
                return .note(state)
            case .bankCard(let item):
                let state = BankCardItemState(item)
                return .bankCard(state)
            case .wifi(let item):
                let state = WifiItemState(item, dependency: dependency.wifiDependency)
                return .wifi(state)
            case .bankAccount(let item):
                let state = BankAccountItemState(item)
                return .bankAccount(state)
            case .custom(let item):
                let state = CustomItemState(item)
                return .custom(state)
            }
        }
    }
    
    var created: Date {
        editedStoreItem.created
    }
    
    var modified: Date {
        editedStoreItem.modified
    }
    
    func addSecondaryItem(with type: SecureItemType) {
        let element: Element
        switch type {
        case .password:
            let state = PasswordItemState(dependency: dependency.passwordDependency)
            element = .password(state)
        case .login:
            let state = LoginItemState(dependency: dependency.loginDependency)
            element = .login(state)
        case .file:
            fatalError()
        case .note:
            let state = NoteItemState()
            element = .note(state)
        case .bankCard:
            let state = BankCardItemState()
            element = .bankCard(state)
        case .wifi:
            let state = WifiItemState(dependency: dependency.wifiDependency)
            element = .wifi(state)
        case .bankAccount:
            let state = BankAccountItemState()
            element = .bankAccount(state)
        case .custom:
            let state = CustomItemState()
            element = .custom(state)
        }
        
        secondaryItems.append(element)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItems.remove(at: index)
    }
    
    func save() async throws {
        do {
            let id = editedStoreItem.id
            let name = title
            let primaryItem = primaryItem.secureItem
            let secondaryItems = secondaryItems.map(\.secureItem)
            let created = editedStoreItem.created
            let modified = Date.now
            let storeItem = StoreItem(id: id, name: name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
            try await dependency.save(storeItem)
        } catch {
            
        }
    }
    
    func delete() async {
        do {
            try await dependency.delete(itemID: editedStoreItem.id)
        } catch {
            
        }
    }
    
}

extension StoreItemEditState {
    
    enum Element  {
        
        case login(LoginItemState)
        case password(PasswordItemState)
        case file(FileItemState)
        case note(NoteItemState)
        case bankCard(BankCardItemState)
        case wifi(WifiItemState)
        case bankAccount(BankAccountItemState)
        case custom(CustomItemState)
        
        @MainActor
        var secureItem: SecureItem {
            switch self {
            case .login(let loginState):
                return .login(loginState.item)
            case .password(let passwordState):
                return .password(passwordState.item)
            case .file(let fileState):
                return .file(fileState.item)
            case .note(let noteState):
                return .note(noteState.item)
            case .bankCard(let bankCardState):
                return .bankCard(bankCardState.item)
            case .wifi(let wifiState):
                return .wifi(wifiState.item)
            case .bankAccount(let bankAccountState):
                return .bankAccount(bankAccountState.item)
            case .custom(let customState):
                return .custom(customState.item)
            }
        }
        
    }
    
}
