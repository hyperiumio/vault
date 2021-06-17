import Combine
import Crypto
import Foundation
import Preferences
import Persistence

@MainActor
protocol ChangeMasterPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var state: ChangeMasterPasswordState { get }
    
    
    func changeMasterPassword() async
    
}



@MainActor
class ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var password = "" {
        didSet {
            state = .waiting
        }
    }
    
    @Published var repeatedPassword = "" {
        didSet {
            state = .waiting
        }
    }
    
    @Published private(set) var state = ChangeMasterPasswordState.waiting
    
    private let vault: Store
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vault: Store, preferences: Preferences, keychain: Keychain) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func changeMasterPassword() async {
        
        state = await transition(from: state)
        
        @MainActor func transition(from state: ChangeMasterPasswordState) async -> ChangeMasterPasswordState {
            switch state {
            case .waiting, .passwordMismatch, .changeDidFail, .passwordChanged   :
                guard password == repeatedPassword else {
                    return .passwordMismatch
                }
                return .passwordChanged
            case .changingPassword:
                return state
            }
        }
    }
    
}

enum ChangeMasterPasswordState {
    
    case waiting
    case changingPassword
    case passwordMismatch
    case changeDidFail
    case passwordChanged
    
}

#if DEBUG
class ChangeMasterPasswordModelStub: ChangeMasterPasswordModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var state = ChangeMasterPasswordState.waiting
    
    func changeMasterPassword() async {}
    
}
#endif
