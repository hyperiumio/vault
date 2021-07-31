import Foundation

public struct BankAccountItem: Equatable, Codable  {
    
    public let accountHolder: String?
    public let iban: String?
    public let bic: String?
    
    public init(accountHolder: String? = nil, iban: String? = nil, bic: String? = nil) {
        self.accountHolder = accountHolder
        self.iban = iban
        self.bic = bic
    }
    
}

extension BankAccountItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .bankAccount }
    
}
