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
    
    public var value: SecureItemValue {
        switch self {
        case .password(let value):
            return value
        case .login(let value):
            return value
        case .file(let value):
            return value
        case .note(let value):
            return value
        case .bankCard(let value):
            return value
        case .wifi(let value):
            return value
        case .bankAccount(let value):
            return value
        case .custom(let value):
            return value
        }
    }
    
    public init(from data: Data, as type: SecureItemType) throws {
        switch type {
        case .password:
            let value = try PasswordItem(from: data)
            self = .password(value)
        case .login:
            let value = try LoginItem(from: data)
            self = .login(value)
        case .file:
            let value = try FileItem(from: data)
            self = .file(value)
        case .note:
            let value = try NoteItem(from: data)
            self = .note(value)
        case .bankCard:
            let value = try BankCardItem(from: data)
            self = .bankCard(value)
        case .wifi:
            let value = try WifiItem(from: data)
            self = .wifi(value)
        case .bankAccount:
            let value = try BankAccountItem(from: data)
            self = .bankAccount(value)
        case .custom:
            let value = try CustomItem(from: data)
            self = .custom(value)
        }
    }
    
}

public protocol SecureItemValue {
    
    var secureItemType: SecureItemType { get }

    func encoded() throws -> Data
    
    init(from data: Data) throws
    
    static var secureItemType: SecureItemType { get }
    
}

extension SecureItemValue {
    
    public var secureItemType: SecureItemType { Self.secureItemType }
    
}

