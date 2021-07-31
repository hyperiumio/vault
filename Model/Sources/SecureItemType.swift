public enum SecureItemType: String, CaseIterable, Identifiable, Codable {
    
    case login
    case password
    case wifi
    case note
    case bankCard
    case bankAccount
    case custom
    case file
    
    public var id: Self { self }
    
}
