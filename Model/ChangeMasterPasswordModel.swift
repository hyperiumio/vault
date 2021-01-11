import Combine
import Identifier
import Crypto
import Foundation
import Preferences
import Storage

protocol ChangeMasterPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var isLoading: Bool { get }
    var done: AnyPublisher<Void, Never> { get }
    var error: AnyPublisher<ChangeMasterPasswordError, Never> { get }
    
    func reset()
    func changeMasterPassword()
    
}

class ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var isLoading = false
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<ChangeMasterPasswordError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let vault: Store
    private let preferences: Preferences
    private let keychain: Keychain
    private let doneSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<ChangeMasterPasswordError, Never>()
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    init(vault: Store, preferences: Preferences, keychain: Keychain) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func changeMasterPassword() {
        guard password == repeatedPassword else {
            self.errorSubject.send(.passwordMismatch)
            return
        }
        
        // missing
    }
    
    func reset() {
        password = ""
        repeatedPassword = ""
        isLoading = false
    }
    
}

enum ChangeMasterPasswordError: Identifiable {
    
    case passwordMismatch
    case masterPasswordChangeDidFail
    
    var id: Self { self }
    
}

#if DEBUG
class ChangeMasterPasswordModelStub: ChangeMasterPasswordModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isLoading = false
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<ChangeMasterPasswordError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func cancel() {}
    func changeMasterPassword() {}
    func reset() {}
    
}
#endif
