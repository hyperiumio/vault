import Collection
import Foundation

@MainActor
class MasterPasswordSetupState: ObservableObject {
    
    @Published var masterPassword: String
    @Published private(set) var status = Status.passwordInput
    private let service: AppServiceProtocol
    
    init(masterPassword: String? = nil, service: AppServiceProtocol) {
        self.masterPassword = masterPassword ?? ""
        self.service = service
    }
    
    func presentPasswordConfirmation() {
        status = .needsPasswordConfirmation
    }
    
    func dismissPasswordConfimation() {
        status = .passwordInput
    }
    
    func choosePasswordIfSecure() {
        status = .checkingPasswordSecurity
        
        Task {
            if await service.isPasswordSecure(masterPassword) {
                status = .didChoosePassword
            } else {
                status = .needsPasswordConfirmation
            }
        }
    }
    
    func choosePassword() {
        status = .didChoosePassword
    }
    
}

extension MasterPasswordSetupState {
    
    enum Status {
        
        case passwordInput
        case checkingPasswordSecurity
        case needsPasswordConfirmation
        case didChoosePassword
        
    }
    
}
