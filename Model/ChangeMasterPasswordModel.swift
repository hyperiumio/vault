import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol ChangeMasterPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var currentPassword: String { get set }
    var newPassword: String { get set }
    var repeatedNewPassword: String { get set }
    var status: ChangeMasterPasswordStatus { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func changeMasterPassword()
    
}

enum ChangeMasterPasswordStatus {
    
    case none
    case loading
    case invalidPassword
    case newPasswordMismatch
    case insecureNewPassword
    case masterPasswordChangeDidFail
    
}

class ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var repeatedNewPassword = ""
    @Published private(set) var status = ChangeMasterPasswordStatus.none
    
    var createMasterKeyButtonDisabled: Bool { currentPassword.isEmpty || newPassword.isEmpty || repeatedNewPassword.isEmpty || newPassword.count != repeatedNewPassword.count || status == .loading }
    var done: AnyPublisher<Void, Never> { doneSubject.eraseToAnyPublisher() }
    
    private let store: VaultItemStore
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    init(store: VaultItemStore, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.store = store
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        Publishers.Merge3($currentPassword, $newPassword, $repeatedNewPassword)
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func changeMasterPassword() {
        guard newPassword == repeatedNewPassword else {
            status = .newPasswordMismatch
            return
        }
        
        guard newPassword.count >= 8 else {
            status = .invalidPassword
            return
        }
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            status = .masterPasswordChangeDidFail
            return
        }
        
        // change password
    }
    
}

private enum ChangeMasterPasswordError: Error {
    
    case invalidPassword
    case masterPasswordChangeDidFail
    
}
