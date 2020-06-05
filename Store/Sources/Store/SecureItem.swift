import Foundation

public enum SecureItem: Equatable {
    
    case password(Password)
    case login(Login)
    case file(File)
    case note(Note)
    case bankCard(BankCard)
    case wifi(Wifi)
    case bankAccount(BankAccount)
    case customField(CustomField)
    
    var typeIdentifier: TypeIdentifier {
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
        case .customField:
            return .customField
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
        case customField
        
    }
    
}

extension SecureItem {
    
    static func encoded(_ secureItem: Self) throws -> Data {
        switch secureItem {
        case .password(let value):
            return try Password.jsonEncoded(value)
        case .login(let value):
            return try Login.jsonEncoded(value)
        case .file(let value):
            return try File.jsonEncoded(value)
        case .note(let value):
            return try Note.jsonEncoded(value)
        case .bankCard(let value):
            return try BankCard.jsonEncoded(value)
        case .wifi(let value):
            return try Wifi.jsonEncoded(value)
        case .bankAccount(let value):
            return try BankAccount.jsonEncoded(value)
        case .customField(let value):
            return try CustomField.jsonEncoded(value)
        }
    }
    
    static func decoded(_ encodedSecureItem: Data, asTypeMatching typeIdentifier: TypeIdentifier) throws -> Self {
        switch typeIdentifier {
        case .password:
            let value = try Password.jsonDecoded(encodedSecureItem)
            return .password(value)
        case .login:
            let value = try Login.jsonDecoded(encodedSecureItem)
            return .login(value)
        case .file:
            let value = try File.jsonDecoded(encodedSecureItem)
            return .file(value)
        case .note:
            let value = try Note.jsonDecoded(encodedSecureItem)
            return .note(value)
        case .bankCard:
            let value = try BankCard.jsonDecoded(encodedSecureItem)
            return .bankCard(value)
        case .wifi:
            let value = try Wifi.jsonDecoded(encodedSecureItem)
            return .wifi(value)
        case .bankAccount:
            let value = try BankAccount.jsonDecoded(encodedSecureItem)
            return .bankAccount(value)
        case .customField:
            let value = try CustomField.jsonDecoded(encodedSecureItem)
            return .customField(value)
        }
    }
    
}
