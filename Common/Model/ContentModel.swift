import Combine
import Foundation

class ContentModel: ObservableObject {
    
    @Published var state: State
    
    private var didCreateVaultSubscription: AnyCancellable?
    
    init(masterKeyUrl: URL, vaultUrl: URL) {
        let setupModel = SetupModel(masterKeyUrl: masterKeyUrl)
        self.state = .setup(setupModel)
        
        didCreateVaultSubscription = setupModel.didCreateMasterKey
            .map { masterKey in
                let vaultModel = VaultModel(vaultUrl: vaultUrl, masterKey: masterKey)
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
