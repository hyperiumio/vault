import Combine
import Foundation
import Store
import Sort
import Crypto

protocol VaultItemReferenceModelRepresentable: ObservableObject, Identifiable, AlphabeticCollationElement {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    typealias State = VaultItemReferenceState<VaultItemModel>
    
    var state: State { get }
    var info: VaultItemInfo { get }
    
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
    
    func vaultItemModel(vaultItem: VaultItem) -> VaultItemModel
    
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
    
    let info: VaultItemInfo
    
    private let vault: Vault
    private let dependency: Dependency
    
    init(vault: Vault, info: VaultItemInfo, dependency: Dependency) {
        self.vault = vault
        self.info = info
        self.dependency = dependency
    }
    
    func load() {
        state = .loading
        
        vault.loadVaultItem(with: info.id)
            .map(dependency.vaultItemModel)
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
    let info: VaultItemInfo
    
    func load() {}
    
    init(state: State, info: VaultItemInfo) {
        self.state = state
        self.info = info
    }
    
}
#endif
