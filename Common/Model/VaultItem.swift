enum VaultItem {
    
    case password(Password)
    case login(Login)
    case file(File)
    
    var itemType: ItemType {
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

extension VaultItem {
    
    enum ItemType: String, Codable {
        
        case password
        case login
        case file
        
    }
    
}
