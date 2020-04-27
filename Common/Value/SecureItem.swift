import Foundation

enum SecureItem: Equatable {
    
    case password(Password)
    case login(Login)
    case file(File)
    
    var itemType: SecureItemType {
        switch self {
        case .password:
            return .password
        case .login:
            return .login
        case .file:
            return .file
        }
    }
    
}
