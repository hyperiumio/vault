import Combine
import CryptoKit
import Foundation

class ContentModel: ObservableObject {
    
    @Published var state: State
    
    private var didCreateMasterKeySubscription: AnyCancellable?
    
    init(initialState: InitialState, masterKeyUrl: URL, vaultUrl: URL) {
        let masterKeyPublisher: PassthroughSubject<SymmetricKey, Never>
        switch initialState {
        case .setup:
            let setupModel = SetupModel(masterKeyUrl: masterKeyUrl)
            masterKeyPublisher = setupModel.didCreateMasterKey
            self.state = .setup(setupModel)
        case .locked:
            let loginModel = LoginModel(masterKeyUrl: masterKeyUrl)
            masterKeyPublisher = loginModel.didDecryptMasterKey
            self.state = .locked(loginModel)
        }
        
        didCreateMasterKeySubscription = masterKeyPublisher
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
        case locked(LoginModel)
        case unlocked(VaultModel)
        
    }
    
    enum InitialState {
        
        case setup
        case locked
        
    }
    
}
