import Foundation

public struct BankCardItem: SecureItemValue, Codable, Equatable  {
    
    public let name: String
    public let number: String
    public let expirationDate: Date
    public let pin: String
    
    public var vendor: Vendor {
        Vendor(number)
    }
    
    var type: SecureItemType { .bankCard }
    
    public init(name: String, number: String, expirationDate: Date, pin: String) {
        self.name = name
        self.number = number
        self.expirationDate = expirationDate
        self.pin = pin
    }
    
    init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
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
        case other
        
        public init(_ number : String) {
            switch number.prefix(1) {
            case "5":
                self = .masterCard
            case "4":
                self = .visa
            case "3" where number.prefix(2) == "38":
                self = .americanExpress
            default:
                self = .other
            }
        }
        
    }
}
