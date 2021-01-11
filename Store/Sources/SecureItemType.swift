public enum SecureItemType: String, Codable, CaseIterable, Identifiable {
    
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
