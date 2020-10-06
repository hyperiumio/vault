import Foundation

public enum SecureItem {
    
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
    
    public func encoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        switch self {
        case .password(let value):
            return try encoder.encode(value)
        case .login(let value):
            return try encoder.encode(value)
        case .file(let value):
            return try encoder.encode(value)
        case .note(let value):
            return try encoder.encode(value)
        case .bankCard(let value):
            return try encoder.encode(value)
        case .wifi(let value):
            return try encoder.encode(value)
        case .bankAccount(let value):
            return try encoder.encode(value)
        case .custom(let value):
            return try encoder.encode(value)
        }
    }
    
    public init(from data: Data, asTypeMatching typeIdentifier: TypeIdentifier) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        switch typeIdentifier {
        case .password:
            let value = try decoder.decode(PasswordItem.self, from: data)
            self = .password(value)
        case .login:
            let value = try decoder.decode(LoginItem.self, from: data)
            self = .login(value)
        case .file:
            let value = try decoder.decode(FileItem.self, from: data)
            self = .file(value)
        case .note:
            let value = try decoder.decode(NoteItem.self, from: data)
            self = .note(value)
        case .bankCard:
            let value = try decoder.decode(BankCardItem.self, from: data)
            self = .bankCard(value)
        case .wifi:
            let value = try decoder.decode(WifiItem.self, from: data)
            self = .wifi(value)
        case .bankAccount:
            let value = try decoder.decode(BankAccountItem.self, from: data)
            self = .bankAccount(value)
        case .custom:
            let value = try decoder.decode(CustomItem.self, from: data)
            self = .custom(value)
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
