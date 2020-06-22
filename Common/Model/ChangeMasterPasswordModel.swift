import Combine
import Crypto
import Foundation
import Store

class ChangeMasterPasswordModel: ObservableObject, Identifiable, Completable {
    
    @Published var currentPassword = "" {
        didSet {
            message = nil
        }
    }
    
    @Published var newPassword = "" {
        didSet {
            message = nil
        }
    }
    
    @Published var repeatedNewPassword = "" {
        didSet {
            message = nil
        }
    }
    
    @Published private(set) var isLoading = false
    @Published private(set) var message: Message?
    
    var textInputDisabled: Bool { isLoading }
    
    var createMasterKeyButtonDisabled: Bool { currentPassword.isEmpty || newPassword.isEmpty || repeatedNewPassword.isEmpty || newPassword.count != repeatedNewPassword.count || isLoading }
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    private let vault: Vault<SecureDataCryptor>
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    init(vault: Vault<SecureDataCryptor>) {
        self.vault = vault
    }
    
    func cancel() {
        let result = Result<Completion, Never>.success(.canceled)
        completionPromise?(result)
    }
    
    func changeMasterPassword() {
        message = nil
        
        guard newPassword == repeatedNewPassword else {
            message = .newPasswordMismatch
            return
        }
        
        isLoading = true
        
        changeMasterPasswordSubscription = vault.changeMasterPassword(to: newPassword)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success(let id):
                    let passwordChanged = Completion.passwordChanged(id)
                    let result = Result<Completion, Never>.success(passwordChanged)
                    self.completionPromise?(result)
                case .failure:
                    self.message = .masterPasswordChangeDidFail
                }
            }
    }
    
}

extension ChangeMasterPasswordModel {
    
    enum Message {
        
        case invalidCurrentPassword
        case newPasswordMismatch
        case masterPasswordChangeDidFail
        
    }
    
    enum Completion {
        
        case canceled
        case passwordChanged(UUID)
        
    }
    
}
