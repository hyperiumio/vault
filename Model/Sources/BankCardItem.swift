import Foundation

public struct BankCardItem: Equatable, Codable {
    
    public let name: String?
    public let number: String?
    public let expirationDate: Date?
    public let pin: String?
    
    public init(name: String? = nil, number: String? = nil, expirationDate: Date? = nil, pin: String? = nil) {
        self.name = name
        self.number = number
        self.expirationDate = expirationDate
        self.pin = pin
    }
    
    public var vendor: Vendor? {
        guard let number = number else {
            return nil
        }
        
        return Vendor(number)
    }
    
}

extension BankCardItem: SecureItemValue {
    
    public var secureItemType: SecureItemType { .bankCard }
    
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
