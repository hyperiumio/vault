import Combine

class BankCardDisplayModel: ObservableObject, Identifiable {
    
    var name: String {
        return bankCard.name
    }
    
    var type: String {
        return bankCard.type
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
