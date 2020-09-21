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
    
    public static func encoded(_ secureItem: Self) throws -> Data {
        switch secureItem {
        case .password(let value):
            return try value.jsonEncoded()
        case .login(let value):
            return try value.jsonEncoded()
        case .file(let value):
            return try value.jsonEncoded()
        case .note(let value):
            return try value.jsonEncoded()
        case .bankCard(let value):
            return try value.jsonEncoded()
        case .wifi(let value):
            return try value.jsonEncoded()
        case .bankAccount(let value):
            return try value.jsonEncoded()
        case .custom(let value):
            return try value.jsonEncoded()
        }
    }
    
    public static func decoded(_ encodedSecureItem: Data, asTypeMatching typeIdentifier: TypeIdentifier) throws -> Self {
        switch typeIdentifier {
        case .password:
            let value = try PasswordItem(jsonEncoded: encodedSecureItem)
            return .password(value)
        case .login:
            let value = try LoginItem(jsonEncoded: encodedSecureItem)
            return .login(value)
        case .file:
            let value = try FileItem(jsonEncoded: encodedSecureItem)
            return .file(value)
        case .note:
            let value = try NoteItem(jsonEncoded: encodedSecureItem)
            return .note(value)
        case .bankCard:
            let value = try BankCardItem(jsonEncoded: encodedSecureItem)
            return .bankCard(value)
        case .wifi:
            let value = try WifiItem(jsonEncoded: encodedSecureItem)
            return .wifi(value)
        case .bankAccount:
            let value = try BankAccountItem(jsonEncoded: encodedSecureItem)
            return .bankAccount(value)
        case .custom:
            let value = try CustomItem(jsonEncoded: encodedSecureItem)
            return .custom(value)
        }
    }
    
}
