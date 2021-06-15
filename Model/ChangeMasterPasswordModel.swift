import Combine
import Crypto
import Foundation
import Preferences
import Persistence

@MainActor
protocol ChangeMasterPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var isLoading: Bool { get }
    
    func reset()
    func changeMasterPassword() async
    
}



@MainActor
class ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var isLoading = false
    
    private let vault: Store
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vault: Store, preferences: Preferences, keychain: Keychain) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func changeMasterPassword() async {

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
    
    func cancel() {}
    func changeMasterPassword() async {}
    func reset() {}
    
}
#endif
