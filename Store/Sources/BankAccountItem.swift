import Foundation

public struct BankAccountItem: SecureItemValue, Codable, Equatable  {
    
    public let accountHolder: String?
    public let iban: String?
    public let bic: String?
    
    public var type: SecureItemType { .bankAccount }
    
    public init(accountHolder: String? = nil, iban: String? = nil, bic: String? = nil) {
        self.accountHolder = accountHolder
        self.iban = iban
        self.bic = bic
    }
    
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
