struct BankCard: Codable, Equatable {
    
    let name: String
    
    var type: BankCardType  {
        return BankCardType(number)
    }
    
    let number: String
    
    let validityDate: String
    
    let validFrom: String
    
    let note: String
    
    let pin: String
    
}

extension BankCard {
    enum BankCardType: String, Codable {
        case masterCard
        case visa
        case americanExpress
        case other
        
        init(_ number : String) {
            switch number.prefix(1) {
            case "5":
                self = .masterCard
            case "4":
                self =  .visa
            case "3" where number.prefix(2) == "38":
                self = .americanExpress
            default:
                self = .other
            }
        }
    }
}
