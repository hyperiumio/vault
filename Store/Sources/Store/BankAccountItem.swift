public struct BankAccountItem: BinaryCodable {
    
    public let accountHolder: String
    public let iban: String
    public let bic: String
    
    public init(accountHolder: String, iban: String, bic: String) {
        self.accountHolder = accountHolder
        self.iban = iban
        self.bic = bic
    }
    
}
