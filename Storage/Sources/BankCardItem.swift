import Foundation

public struct BankCardItem: SecureItemValue, Codable, Equatable  {
    
    public let name: String?
    public let number: String?
    public let expirationDate: Date?
    public let pin: String?
    
    public var vendor: Vendor? {
        guard let number = number else {
            return nil
        }
        
        return Vendor(number)
    }
    
    public static var secureItemType: SecureItemType { .bankCard }
    
    public init(name: String? = nil, number: String? = nil, expirationDate: Date? = nil, pin: String? = nil) {
        self.name = name
        self.number = number
        self.expirationDate = expirationDate
        self.pin = pin
    }
    
    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
    
    public func encoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
}

extension BankCardItem {
    
    public enum Vendor {
        
        case masterCard
        case visa
        case americanExpress
        
        public init?(_ number : String) {
            switch number.prefix(1) {
            case "5":
                self = .masterCard
            case "4":
                self = .visa
            case "3" where number.prefix(2) == "38":
                self = .americanExpress
            default:
                return nil
            }
        }
        
    }
}
