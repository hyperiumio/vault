import Combine

class BankCardDisplayModel: ObservableObject, Identifiable {
    @Published var pinSecureDisplay = true
    
    var name: String {
        return bankCard.name
    }
    
    var type: BankCard.BankCardType  {
        return BankCard.BankCardType(number)
    }
    
    var number: String {
        return bankCard.number
    }
    
    var validityDate: String {
        return bankCard.validityDate
    }
    
    var validFrom: String {
        return bankCard.validFrom
    }
    
    var pin: String {
        return bankCard.pin
    }
    
    var cvv: String {
        return bankCard.cvv
    }
    
    private let bankCard: BankCard
    
    init(_ bankCard: BankCard) {
        self.bankCard = bankCard
    }
}
