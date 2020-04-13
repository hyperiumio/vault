import Foundation

func SecureContainerItemEncode(_ item: SecureItem) throws -> Data {
    switch item {
    case .password(let value):
        return try PasswordEncode(value)
    case .login(let value):
        return try LoginEncode(value)
    case .file(let value):
        return try FileEncode(value)
    }
}

func SecureContainerItemDecode(data: Data, as itemType: SecureItemType) throws -> SecureItem {
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
    }
}
