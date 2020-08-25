import Combine
import Foundation
import Store
import Sort

protocol VaultItemReferenceModelRepresentable: ObservableObject, Identifiable, AlphabeticCollationElement {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    typealias VaultItemInfo = VaultItem.Info
    typealias State = VaultItemReferenceState<VaultItemModel>
    
    var state: State { get }
    var info: VaultItemInfo { get }
    
    func load()
    
    init(vault: Vault, info: VaultItem.Info)
    
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

enum VaultItemReferenceState<VaultItemModel> {
    
    case none
    case loading
    case loadingError
    case loaded(VaultItemModel)
    
}

class VaultItemReferenceModel<VaultItemModel>: VaultItemReferenceModelRepresentable where VaultItemModel: VaultItemModelRepresentable {
    
    @Published var state = State.none
    
    let info: VaultItem.Info
    
    private let vault: Vault
    
    required init(vault: Vault, info: VaultItem.Info) {
        self.info = info
        self.vault = vault
    }
    
    func load() {
        state = .loading
        
        vault.loadVaultItem(with: info.id)
            .map { [vault] vaultItem in
                VaultItemModel(vault: vault, vaultItem: vaultItem)
            }
            .map { model in
                .loaded(model)
            }
            .replaceError(with: .loadingError)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}
