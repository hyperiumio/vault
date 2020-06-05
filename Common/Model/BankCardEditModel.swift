import Combine
import Store

class BankCardEditModel: ObservableObject, Identifiable {
    
    @Published var name: String
    @Published var number: String
    @Published var validityDate: String
    @Published var validFrom: String
    @Published var pin: String
    
    var vendor: BankCard.Vendor?  {
        guard isComplete else {
            return nil
        }
        return BankCard.Vendor(number)
    }
    
    var isComplete: Bool {
        let validNumber = number.count > 16
        return !number.isEmpty && validNumber
    }
    
    var secureItem: SecureItem? {
        guard !number.isEmpty else {
            return nil
        }
            
        let bankCard = BankCard(name: name, number: number, validityDate: validityDate, validFrom: validFrom, pin: pin)
        return SecureItem.bankCard(bankCard)
    }
    
    init(_ bankCard: BankCard? = nil) {
        self.name = bankCard?.name ?? ""
        self.number = bankCard?.number ?? ""
        self.validityDate = bankCard?.validityDate ?? ""
        self.validFrom = bankCard?.validFrom ?? ""
        self.pin = bankCard?.pin ?? ""
    }
    
}
