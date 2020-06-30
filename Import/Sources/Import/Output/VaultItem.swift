public struct VaultItem {
    public let title: String
    public let secureItems: [SecureItem]
    
}

public enum SecureItem {
    case password(password: String)
    case login(username: String, password: String)
    case note(note: String)
    case genericItem(key: String?, value: String?)
}
