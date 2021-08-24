import Event
import Foundation

@MainActor
class MasterPasswordSetupState: ObservableObject {
    
    @Published var masterPassword = ""
    @Published private var status = Status.passwordInput
    private let service: AppServiceProtocol
    private let outputMulticast = EventMulticast<Output>()
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    var output: AsyncStream<Output> {
        outputMulticast.events
    }
    
    var canEnterPassword: Bool {
        status == .passwordInput
    }
    
    var canChoosePassword: Bool {
        !masterPassword.isEmpty && status == .passwordInput
    }
    
    var isCheckingPasswordSecurity: Bool {
        status == .checkingPasswordSecurity
    }
    
    var presentsPasswordConfirmation: Bool {
        get {
            status == .needsPasswordConfirmation
        }
        set(needsPasswordConfirmation) {
            status = needsPasswordConfirmation ? .needsPasswordConfirmation : .passwordInput
        }
    }
    
    func choosePasswordIfSecure() {
        status = .checkingPasswordSecurity
        
        Task {
            if await service.isPasswordSecure(masterPassword) {
                status = .didChoosePassword
                outputMulticast.send(.didChoosePassword)
                outputMulticast.finish()
            } else {
                status = .needsPasswordConfirmation
            }
        }
    }
    
    func choosePassword() {
        status = .didChoosePassword
        outputMulticast.send(.didChoosePassword)
        outputMulticast.finish()
    }
    
}

extension MasterPasswordSetupState {
    
    enum Status {
        
        case passwordInput
        case checkingPasswordSecurity
        case needsPasswordConfirmation
        case didChoosePassword
        
    }
    
    enum Output {
        
        case didChoosePassword
        
    }
    
}
