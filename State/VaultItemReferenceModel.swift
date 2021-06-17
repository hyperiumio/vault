import Combine
import Foundation
import Persistence
import Sort
import Crypto

@MainActor
protocol VaultItemReferenceModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    typealias State = VaultItemReferenceState<VaultItemModel>
    
    var state: State { get }
    var info: StoreItemInfo { get }
    var collationIdentifier: VaultItemReferenceModelCollationIdentifier { get }
    
    func load() async
    
}


struct VaultItemReferenceModelCollationIdentifier: CollationElement {
    
    let sectionKey: String = ""
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        true
    }
    
}
/*
extension VaultItemReferenceModelRepresentable: CollationElement {
    
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
    
}*/

@MainActor
protocol VaultItemReferenceModelDependency {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    func vaultItemModel(storeItem: StoreItem, itemLocator: StoreItemLocator) -> VaultItemModel
    
}

@MainActor
class VaultItemReferenceModel<Dependency: VaultItemReferenceModelDependency>: VaultItemReferenceModelRepresentable {
    
    typealias VaultItemModel = Dependency.VaultItemModel
    
    @Published private(set) var state = State.initialized
    
    let info: StoreItemInfo
    
    private let itemLocator: StoreItemLocator
    private let store: Store
    private let masterKey: MasterKey
    private let dependency: Dependency
    
    init(info: StoreItemInfo, itemLocator: StoreItemLocator, store: Store, masterKey: MasterKey, dependency: Dependency) {
        self.info = info
        self.itemLocator = itemLocator
        self.store = store
        self.masterKey = masterKey
        self.dependency = dependency
    }
    
    var collationIdentifier: VaultItemReferenceModelCollationIdentifier {
        VaultItemReferenceModelCollationIdentifier()
    }
    
    func load() async {

    }
    
}

enum VaultItemReferenceState<VaultItemModel> {
    
    case initialized
    case loading
    case loadingFailed
    case loaded(VaultItemModel)
    
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
    
    var collationIdentifier: VaultItemReferenceModelCollationIdentifier {
        VaultItemReferenceModelCollationIdentifier()
    }
    
}
#endif
