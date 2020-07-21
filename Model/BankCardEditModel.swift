import Combine
import Store

class BankCardEditModel: ObservableObject, Identifiable {
    
    @Published var name: String
    @Published var number: String
    @Published var validityDate: String
    @Published var validFrom: String
    @Published var pin: String
    
    var vendor: BankCardItem.Vendor? { isComplete ? BankCardItem.Vendor(number) : nil }
    
    var isComplete: Bool { !number.isEmpty && number.count > 16 }
    
    var secureItem: SecureItem? {
        guard !number.isEmpty else { return nil }
            
        let bankCard = BankCardItem(name: name, number: number, validityDate: validityDate, validFrom: validFrom, pin: pin)
        return SecureItem.bankCard(bankCard)
    }
    
    init(_ bankCard: BankCardItem) {
        self.name = bankCard.name
        self.number = bankCard.number
        self.validityDate = bankCard.validityDate
        self.validFrom = bankCard.validFrom
        self.pin = bankCard.pin
    }
    
    init() {
        self.name = ""
        self.number = ""
        self.validityDate = ""
        self.validFrom = ""
        self.pin = ""
    }
    
}
