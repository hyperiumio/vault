import Combine
import Foundation
import Storage
import Sort
import Crypto

protocol VaultItemReferenceModelRepresentable: ObservableObject, Identifiable, AlphabeticCollationElement {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    typealias State = VaultItemReferenceState<VaultItemModel>
    
    var state: State { get }
    var info: StoreItemInfo { get }
    
    func load()
    
}

extension VaultItemReferenceModelRepresentable {
    
    var sectionKey: String {
        let firstCharacter = info.name.prefix(1)
        return String(firstCharacter)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.info.name < rhs.info.name
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.info.name == rhs.info.name
    }
    
}

protocol VaultItemReferenceModelDependency {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    func vaultItemModel(storeItem: StoreItem, itemLocator: Store.ItemLocator) -> VaultItemModel
    
}


enum VaultItemReferenceState<VaultItemModel> {
    
    case initialized
    case loading
    case loadingFailed
    case loaded(VaultItemModel)
    
}

class VaultItemReferenceModel<Dependency: VaultItemReferenceModelDependency>: VaultItemReferenceModelRepresentable {
    
    typealias VaultItemModel = Dependency.VaultItemModel
    
    @Published private(set) var state = State.initialized
    
    let info: StoreItemInfo
    
    private let itemLocator: Store.ItemLocator
    private let store: Store
    private let masterKey: MasterKey
    private let dependency: Dependency
    
    init(info: StoreItemInfo, itemLocator: Store.ItemLocator, store: Store, masterKey: MasterKey, dependency: Dependency) {
        self.info = info
        self.itemLocator = itemLocator
        self.store = store
        self.masterKey = masterKey
        self.dependency = dependency
    }
    
    func load() {
        state = .loading
        
        store.loadItem(itemLocator: itemLocator) { [masterKey] encryptedItemData in
            try SecureDataMessage.decryptMessages(from: encryptedItemData, using: masterKey)
        }
        .map { [dependency, itemLocator] storeItem in
            dependency.vaultItemModel(storeItem: storeItem, itemLocator: itemLocator)
        }
        .map(VaultItemReferenceState.loaded)
        .replaceError(with: .loadingFailed)
        .receive(on: DispatchQueue.main)
        .assign(to: &$state)
    }
    
}

#if DEBUG
class VaultItemReferenceModelStub: VaultItemReferenceModelRepresentable {
    
    typealias VaultItemModel = VaultItemModelStub
    
    let state: State
    let info: StoreItemInfo
    
    func load() {}
    
    init(state: State, info: StoreItemInfo) {
        self.state = state
        self.info = info
    }
    
}
#endif
