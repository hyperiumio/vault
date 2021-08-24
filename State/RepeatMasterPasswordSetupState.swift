import Event
import Foundation

@MainActor
class RepeatMasterPasswordSetupState: ObservableObject {
    
    @Published var repeatedPassword = ""
    @Published private var status = Status.passwordInput
    private let masterPassword: String
    private let outputMulticast = EventMulticast<Output>()
    
    init(masterPassword: String) {
        self.masterPassword = masterPassword
    }
    
    var output: AsyncStream<Output> {
        outputMulticast.events
    }
    
    var canEnterPassword: Bool {
        status == .passwordInput
    }
    
    var canChooseRepeatedPassword: Bool {
        !repeatedPassword.isEmpty && status == .passwordInput
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
            outputMulticast.send(.didRepeatPassword)
            outputMulticast.finish()
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
    
    enum Output {
        
        case didRepeatPassword
        
    }
    
}
