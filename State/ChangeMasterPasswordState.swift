import Combine
import Crypto
import Foundation
import Preferences
import Model

@MainActor
protocol ChangeMasterPasswordStateRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var state: ChangeMasterPasswordStatus { get }
    
    
    func changeMasterPassword() async
    
}



@MainActor
class ChangeMasterPasswordState: ChangeMasterPasswordStateRepresentable {
    
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
    
    @Published private(set) var state = ChangeMasterPasswordStatus.waiting
    
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
        
        @MainActor func transition(from state: ChangeMasterPasswordStatus) async -> ChangeMasterPasswordStatus {
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

enum ChangeMasterPasswordStatus {
    
    case waiting
    case changingPassword
    case passwordMismatch
    case changeDidFail
    case passwordChanged
    
}

#if DEBUG
class ChangeMasterPasswordStateStub: ChangeMasterPasswordStateRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var state = ChangeMasterPasswordStatus.waiting
    
    func changeMasterPassword() async {}
    
}
#endif
