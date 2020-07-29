import Foundation

public enum SecureItem: Equatable {
    
    case password(PasswordItem)
    case login(LoginItem)
    case file(FileItem)
    case note(NoteItem)
    case bankCard(BankCardItem)
    case wifi(WiFiItem)
    case bankAccount(BankAccountItem)
    case generic(GenericItem)
    
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
        case .generic:
            return .generic
        }
    }
    
}

public extension SecureItem {
    
    enum TypeIdentifier: String, Codable {
        
        case password
        case login
        case file
        case note
        case bankCard
        case wifi
        case bankAccount
        case generic
        
    }
    
}

extension SecureItem {
    
    static func encoded(_ secureItem: Self) throws -> Data {
        switch secureItem {
        case .password(let value):
            return try PasswordItem.jsonEncoded(value)
        case .login(let value):
            return try LoginItem.jsonEncoded(value)
        case .file(let value):
            return try FileItem.jsonEncoded(value)
        case .note(let value):
            return try NoteItem.jsonEncoded(value)
        case .bankCard(let value):
            return try BankCardItem.jsonEncoded(value)
        case .wifi(let value):
            return try WiFiItem.jsonEncoded(value)
        case .bankAccount(let value):
            return try BankAccountItem.jsonEncoded(value)
        case .generic(let value):
            return try GenericItem.jsonEncoded(value)
        }
    }
    
    static func decoded(_ encodedSecureItem: Data, asTypeMatching typeIdentifier: TypeIdentifier) throws -> Self {
        switch typeIdentifier {
        case .password:
            let value = try PasswordItem.jsonDecoded(encodedSecureItem)
            return .password(value)
        case .login:
            let value = try LoginItem.jsonDecoded(encodedSecureItem)
            return .login(value)
        case .file:
            let value = try FileItem.jsonDecoded(encodedSecureItem)
            return .file(value)
        case .note:
            let value = try NoteItem.jsonDecoded(encodedSecureItem)
            return .note(value)
        case .bankCard:
            let value = try BankCardItem.jsonDecoded(encodedSecureItem)
            return .bankCard(value)
        case .wifi:
            let value = try WiFiItem.jsonDecoded(encodedSecureItem)
            return .wifi(value)
        case .bankAccount:
            let value = try BankAccountItem.jsonDecoded(encodedSecureItem)
            return .bankAccount(value)
        case .generic:
            let value = try GenericItem.jsonDecoded(encodedSecureItem)
            return .generic(value)
        }
    }
    
}
