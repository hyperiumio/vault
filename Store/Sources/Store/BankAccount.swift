public struct BankAccount: JSONCodable {
    
    public let bankName: String
    public let accountHolder: String
    public let bankCode: String
    public let accountNumber: String
    public let swiftCode: String
    public let iban: String
    public let pin: String
    public let onlineBankingUrl: String
    
    public init(bankName: String, accountHolder: String, bankCode: String, accountNumber: String, swiftCode: String, iban: String, pin: String, onlineBankingUrl: String) {
        self.bankName = bankName
        self.accountHolder = accountHolder
        self.bankCode = bankCode
        self.accountNumber = accountNumber
        self.swiftCode = swiftCode
        self.iban = iban
        self.pin = pin
        self.onlineBankingUrl = onlineBankingUrl
    }
    
}
