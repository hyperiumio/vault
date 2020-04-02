import Combine
import Foundation

class ContentModel: ObservableObject {
    
    @Published var state: State
    
    private var didCreateVaultSubscription: AnyCancellable?
    
    init(vaultUrl: URL) {
        let setupModel = SetupModel(vaultUrl: vaultUrl)
        self.state = .setup(setupModel)
        
        didCreateVaultSubscription = setupModel.didCreateVault
            .sink { vault in
            
            }
    }
    
}

extension ContentModel {
    
    enum State {
        
        case setup(SetupModel)
        
    }
    
}
