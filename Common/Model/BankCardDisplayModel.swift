import Combine

class BankCardDisplayModel: ObservableObject, Identifiable {
    @Published var secureDisplay = true
    
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
    
    var note: String {
        return bankCard.note
    }
    
    var pin: String {
        return bankCard.pin
    }
    
    private let bankCard: BankCard
    
    init(_ bankCard: BankCard) {
        self.bankCard = bankCard
    }
}
