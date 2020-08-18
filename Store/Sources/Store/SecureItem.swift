import Foundation

public enum SecureItem: Equatable {
    
    case password(PasswordItem)
    case login(LoginItem)
    case file(FileItem)
    case note(NoteItem)
    case bankCard(BankCardItem)
    case wifi(WifiItem)
    case bankAccount(BankAccountItem)
    case custom(CustomItem)
    
    public var typeIdentifier: TypeIdentifier {
        switch self {
        case .password:
            return .password
        case .login:
            return .login
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
}

public extension SecureItem {
    
    enum TypeIdentifier: String, Codable, CaseIterable, Identifiable {
        
        case login
        case password
        case wifi
        case note
        case bankCard
        case bankAccount
        case custom
        case file
     
        public var id: TypeIdentifier { self }
        
    }
    
}

extension SecureItem {
    
    static func encoded(_ secureItem: Self) throws -> Data {
        switch secureItem {
        case .password(let value):
            return try value.binaryEncoded()
        case .login(let value):
            return try value.binaryEncoded()
        case .file(let value):
            return try value.binaryEncoded()
        case .note(let value):
            return try value.binaryEncoded()
        case .bankCard(let value):
            return try value.binaryEncoded()
        case .wifi(let value):
            return try value.binaryEncoded()
        case .bankAccount(let value):
            return try value.binaryEncoded()
        case .custom(let value):
            return try value.binaryEncoded()
        }
    }
    
    static func decoded(_ encodedSecureItem: Data, asTypeMatching typeIdentifier: TypeIdentifier) throws -> Self {
        switch typeIdentifier {
        case .password:
            let value = try PasswordItem(binaryEncoded: encodedSecureItem)
            return .password(value)
        case .login:
            let value = try LoginItem(binaryEncoded: encodedSecureItem)
            return .login(value)
        case .file:
            let value = try FileItem(binaryEncoded: encodedSecureItem)
            return .file(value)
        case .note:
            let value = try NoteItem(binaryEncoded: encodedSecureItem)
            return .note(value)
        case .bankCard:
            let value = try BankCardItem(binaryEncoded: encodedSecureItem)
            return .bankCard(value)
        case .wifi:
            let value = try WifiItem(binaryEncoded: encodedSecureItem)
            return .wifi(value)
        case .bankAccount:
            let value = try BankAccountItem(binaryEncoded: encodedSecureItem)
            return .bankAccount(value)
        case .custom:
            let value = try CustomItem(binaryEncoded: encodedSecureItem)
            return .custom(value)
        }
    }
    
}
