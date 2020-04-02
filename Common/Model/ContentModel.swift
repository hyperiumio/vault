import Combine
import Foundation

class ContentModel: ObservableObject {
    
    @Published var state: State
    
    private var didCreateVaultSubscription: AnyCancellable?
    
    init(vaultUrl: URL) {
        let setupModel = SetupModel(vaultUrl: vaultUrl)
        self.state = .setup(setupModel)
        
        didCreateVaultSubscription = setupModel.didCreateVault
            .map { vault in
                let vaultModel = VaultModel(vault: vault)
                return State.unlocked(vaultModel)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
    }
    
}

extension ContentModel {
    
    enum State {
        
        case setup(SetupModel)
        case unlocked(VaultModel)
        
    }
    
}
