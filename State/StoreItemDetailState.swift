import Foundation
import Model

@MainActor
class StoreItemDetailState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: Element
    @Published private(set) var secondaryItems: [Element]
    @Published private(set) var mode = Mode.display
    
    private let storeItem: StoreItem
    
    init(storeItem: StoreItem) {
        self.storeItem = storeItem
        self.title = storeItem.name
        self.primaryItem = Element(from: storeItem.primaryItem)
        self.secondaryItems = storeItem.secondaryItems.map { item in
            Element(from: item)
        }
    }
    
    var created: Date {
        storeItem.created
    }
    
    var modified: Date {
        storeItem.modified
    }
    
    func editMode() {
        mode = .edit
    }
    
    func addSecondaryItem(with type: SecureItemType) {
        let secureItem = Element(from: type)
        secondaryItems.append(secureItem)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItems.remove(at: index)
    }
    
    func discardChanges() {
        title = storeItem.name
        primaryItem = Element(from: storeItem.primaryItem)
        secondaryItems = storeItem.secondaryItems.map { item in
            Element(from: item)
        }
        mode = .display
    }
    
    func save() async throws {
        mode = .display
        /*
        let id = originalStoreItem?.id ?? UUID()
        let primaryItem = primaryItem.secureItem
        let secondaryItems = secondaryItems.map(\.secureItem)
        let created = originalStoreItem?.created ?? Date.now
        let modified = created
        let storeItem = StoreItem(id: id, name: title, primaryItem: primaryItem, secondaryItems: secondaryItems, created: created, modified: modified)
        
        let operations = [
            StoreOperation.save(storeItem, originalItemLocator, encrypt)
        ]
        try await store.commit(operations: operations)
        
        mode = .display
        
        func encrypt(messages: [Data]) throws -> Data {
            try SecureDataMessage.encryptContainer(from: messages, using: masterKey)
        }
         */
    }
    
    func delete() async throws {
        /*
        guard let itemLocator = originalItemLocator else {
            return
        }
        
        let operations = [
            StoreOperation.delete(itemLocator)
        ]
        try await store.commit(operations: operations)
         */
    }
    
}

extension StoreItemDetailState {
    
    typealias StoreItem = Model.StoreItem
    typealias SecureItem = Model.SecureItem
    typealias LoginItem = Model.LoginItem
    typealias PasswordItem = Model.PasswordItem
    typealias FileItem = Model.FileItem
    typealias NoteItem = Model.NoteItem
    typealias BankCardItem = Model.BankCardItem
    typealias WifiItem = Model.WifiItem
    typealias BankAccountItem = Model.BankAccountItem
    typealias CustomItem = Model.CustomItem
    
    enum Mode {
        
        case display
        case edit
        
    }
    
    enum Element  {
        
        case login(LoginState)
        case password(PasswordState)
        case file(FileState)
        case note(NoteState)
        case bankCard(BankCardState)
        case wifi(WifiState)
        case bankAccount(BankAccountState)
        case custom(CustomState)
        
        @MainActor
        init(from secureItem: SecureItem) {
            switch secureItem {
            case .password(let item):
                let state = PasswordState(item)
                self = .password(state)
            case .login(let item):
                let state = LoginState(item)
                self = .login(state)
            case .file(let item):
                let state = FileState(item)
                self = .file(state)
            case .note(let item):
                let state = NoteState(item)
                self = .note(state)
            case .bankCard(let item):
                let state = BankCardState(item)
                self = .bankCard(state)
            case .wifi(let item):
                let state = WifiState(item)
                self = .wifi(state)
            case .bankAccount(let item):
                let state = BankAccountState(item)
                self = .bankAccount(state)
            case .custom(let item):
                let state = CustomState(item)
                self = .custom(state)
            }
        }
        
        @MainActor
        init(from secureItemType: SecureItemType) {
            switch secureItemType {
            case .password:
                let state = PasswordState()
                self = .password(state)
            case .login:
                let state = LoginState()
                self = .login(state)
            case .file:
                fatalError()
            case .note:
                let state = NoteState()
                self = .note(state)
            case .bankCard:
                let state = BankCardState()
                self = .bankCard(state)
            case .wifi:
                let state = WifiState()
                self = .wifi(state)
            case .bankAccount:
                let state = BankAccountState()
                self = .bankAccount(state)
            case .custom:
                let state = CustomState()
                self = .custom(state)
            }
        }
        
    }
    
}
