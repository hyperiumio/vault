import Foundation

func SecureItemEncode(_ item: SecureItem) throws -> Data {
    switch item {
    case .password(let value):
        return try PasswordEncode(value)
    case .login(let value):
        return try LoginEncode(value)
    case .file(let value):
        return try FileEncode(value)
    case .note(let value):
        return try NoteEncode(value)
    case .bankCard(let value):
        return try BankCardEncode(value)
    case .wifi(let value):
        return try WifiEncode(value)
    case .bankAccount(let value):
        return try BankAccountEncode(value)
    case .customField(let value):
        return try CustomFieldEncode(value)
    }
}

func SecureItemDecode(data: Data, as itemType: SecureItemType) throws -> SecureItem {
    switch itemType {
    case .password:
        let value = try PasswordDecode(data: data)
        return .password(value)
    case .login:
        let value = try LoginDecode(data: data)
        return .login(value)
    case .file:
        let value = try FileDecode(data: data)
        return .file(value)
    case .note:
        let value = try NoteDecode(data: data)
        return .note(value)
    case .bankCard:
        let value = try BankCardDecode(data: data)
        return .bankCard(value)
    case .wifi:
        let value = try WifiDecode(data: data)
        return .wifi(value)
    case .bankAccount:
        let value = try BankAccountDecode(data: data)
        return .bankAccount(value)
    case .customField:
        let value = try CustomFieldDecode(data: data)
        return .customField(value)
    }
}
