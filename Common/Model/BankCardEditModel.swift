import Combine

class BankCardEditModel: ObservableObject, Identifiable {
    @Published var secureDisplay = true

    @Published var name: String
    
    var type: BankCard.BankCardType?  {
        guard isComplete else {
            return nil
        }
        return BankCard.BankCardType(number)
    }
    
    @Published var number: String
    
    @Published var validityDate: String
    
    @Published var validFrom: String
    
    @Published var note: String
    
    @Published var pin: String
    
    var isComplete: Bool {
        let validNumber = number.count > 16
        return !number.isEmpty && validNumber
    }
    
    var secureItem: SecureItem? {
        guard !number.isEmpty else {
            return nil
        }
            
        let bankCard = BankCard(name: name, number: number, validityDate: validityDate, validFrom: validFrom, note: note, pin: pin)
        return SecureItem.bankCard(bankCard)
    }
    
    init(_ bankCard: BankCard? = nil) {
        self.name = bankCard?.name ?? ""
        self.number = bankCard?.number ?? ""
        self.validityDate = bankCard?.validityDate ?? ""
        self.validFrom = bankCard?.validFrom ?? ""
        self.note = bankCard?.note ?? ""
        self.pin = bankCard?.pin ?? ""
    }
    
}
