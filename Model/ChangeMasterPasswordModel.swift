import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol ChangeMasterPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var currentPassword: String { get set }
    var newPassword: String { get set }
    var repeatedNewPassword: String { get set }
    var textInputDisabled: Bool { get }
    var status: ChangeMasterPasswordModel.Status { get }
    
    func cancel()
    func changeMasterPassword()
    
}

class ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var repeatedNewPassword = ""
    @Published private(set) var status = Status.none
    
    var textInputDisabled: Bool { status == .loading }
    var createMasterKeyButtonDisabled: Bool { currentPassword.isEmpty || newPassword.isEmpty || repeatedNewPassword.isEmpty || newPassword.count != repeatedNewPassword.count || status == .loading }
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let vault: Vault
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        Publishers.Merge3($currentPassword, $newPassword, $repeatedNewPassword)
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func cancel() {
        eventSubject.send(.canceled)
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

extension ChangeMasterPasswordModel {
    
    enum Status {
        
        case none
        case loading
        case invalidPassword
        case newPasswordMismatch
        case insecureNewPassword
        case masterPasswordChangeDidFail
        
    }
    
    enum Event {
        
        case canceled
        case passwordChanged
        
    }
    
}

private enum ChangeMasterPasswordError: Error {
    
    case invalidPassword
    case masterPasswordChangeDidFail
    
}
