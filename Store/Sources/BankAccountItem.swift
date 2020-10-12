import Foundation

public struct BankAccountItem: SecureItemValue, Codable, Equatable  {
    
    public let accountHolder: String
    public let iban: String
    public let bic: String
    
    var type: SecureItemType { .bankAccount }
    
    public init(accountHolder: String, iban: String, bic: String) {
        self.accountHolder = accountHolder
        self.iban = iban
        self.bic = bic
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
