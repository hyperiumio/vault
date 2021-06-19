import Combine
import Foundation
import Model
import Sort
import Crypto

#warning("Todo")
@MainActor
protocol VaultItemReferenceStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype VaultItemState: VaultItemStateRepresentable
    
    typealias Status = VaultItemReferenceStatus<VaultItemState>
    
    var status: Status { get }
    var info: StoreItemInfo { get }
    var collationIdentifier: VaultItemReferenceStateCollationIdentifier { get }
    
    func load() async
    
}


struct VaultItemReferenceStateCollationIdentifier: CollationElement {
    
    let sectionKey: String = ""
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        true
    }
    
}
/*
extension VaultItemReferenceStateRepresentable: CollationElement {
    
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
protocol VaultItemReferenceStateDependency {
    
    associatedtype VaultItemState: VaultItemStateRepresentable
    
    func vaultItemState(storeItem: StoreItem, itemLocator: StoreItemLocator) -> VaultItemState
    
}

@MainActor
class VaultItemReferenceState<Dependency: VaultItemReferenceStateDependency>: VaultItemReferenceStateRepresentable {
    
    typealias VaultItemState = Dependency.VaultItemState
    
    @Published private(set) var status = Status.initialized
    
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
    
    var collationIdentifier: VaultItemReferenceStateCollationIdentifier {
        VaultItemReferenceStateCollationIdentifier()
    }
    
    func load() async {

    }
    
}

enum VaultItemReferenceStatus<VaultItemState> {
    
    case initialized
    case loading
    case loadingFailed
    case loaded(VaultItemState)
    
}


#if DEBUG
class VaultItemReferenceStateStub: VaultItemReferenceStateRepresentable {
    
    typealias VaultItemState = VaultItemStateStub
    
    let status: Status
    let info: StoreItemInfo
    
    init(status: Status, info: StoreItemInfo) {
        self.status = status
        self.info = info
    }
    
    var collationIdentifier: VaultItemReferenceStateCollationIdentifier {
        VaultItemReferenceStateCollationIdentifier()
    }
    
    func load() async { }
    
}
#endif
