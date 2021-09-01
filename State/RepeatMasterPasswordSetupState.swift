import Event
import Foundation

@MainActor
class RepeatMasterPasswordSetupState: ObservableObject {
    
    @Published var repeatedPassword: String
    @Published private(set) var status = Status.passwordInput
    private let masterPassword: String
    
    init(masterPassword: String, repeatedPassword: String? = nil) {
        self.masterPassword = masterPassword
        self.repeatedPassword = repeatedPassword ?? ""
    }
    
    var presentsPasswordMismatch: Bool {
        get {
            status == .passwordMismatch
        }
        set(presentsPasswordMismatch) {
            status = presentsPasswordMismatch ? .passwordMismatch : .passwordInput
        }
    }
    
    func checkRepeatedPassword() {
        if repeatedPassword == masterPassword {
            status = .passwordRepeated
        } else {
            status = .passwordMismatch
        }
    }
    
}

extension RepeatMasterPasswordSetupState {
    
    enum Status {
        
        case passwordInput
        case passwordMismatch
        case passwordRepeated
        
    }
    
}
