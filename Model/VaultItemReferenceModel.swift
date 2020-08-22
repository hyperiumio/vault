import Combine
import Foundation
import Store

protocol VaultItemReferenceModelRepresentable: ObservableObject, Identifiable {
    
    var state: VaultItemReferenceModel.State { get }
    
    func load()
    
}

class VaultItemReferenceModel: VaultItemReferenceModelRepresentable {
    
    @Published var state = State.none
    
    let info: VaultItem.Info
    
    private let vault: Vault
    
    init(vault: Vault, info: VaultItem.Info) {
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
                State.loaded(model)
            }
            .replaceError(with: .loadingError)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

extension VaultItemReferenceModel {
    
    enum State {
        
        case none
        case loading
        case loadingError
        case loaded(VaultItemModel)
        
    }
    
}
