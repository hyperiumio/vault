import Combine
import Foundation

class LoginModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = .none
        }
    }
    
    @Published var isLoading = false
    @Published var message = Message.none
    
    var userInputDisabled: Bool {
        return isLoading
    }
    
    func login() {
        message = .invalidPassword
    }
    
}

extension LoginModel {
    
    enum Message {
        
        case none
        case invalidPassword
        
    }
    
}
