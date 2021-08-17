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
    
    public init(from itemData: Data, as type: SecureItemType) throws {
        switch type {
        case .password:
            let value = try PasswordItem(from: itemData)
            self = .password(value)
        case .login:
            let value = try LoginItem(from: itemData)
            self = .login(value)
        case .file:
            let value = try FileItem(from: itemData)
            self = .file(value)
        case .note:
            let value = try NoteItem(from: itemData)
            self = .note(value)
        case .bankCard:
            let value = try BankCardItem(from: itemData)
            self = .bankCard(value)
        case .wifi:
            let value = try WifiItem(from: itemData)
            self = .wifi(value)
        case .bankAccount:
            let value = try BankAccountItem(from: itemData)
            self = .bankAccount(value)
        case .custom:
            let value = try CustomItem(from: itemData)
            self = .custom(value)
        }
    }
    
    public var value: SecureItemValue {
        switch self {
        case let .password(value):
            return value
        case let .login(value):
            return value
        case let .file(value):
            return value
        case let .note(value):
            return value
        case let .bankCard(value):
            return value
        case let .wifi(value):
            return value
        case let .bankAccount(value):
            return value
        case let .custom(value):
            return value
        }
    }
    
}
