import Combine
import Store

class BankCardEditModel: ObservableObject, Identifiable {
    
    @Published var name: String
    @Published var number: String
    @Published var validityDate: String
    @Published var validFrom: String
    @Published var pin: String
    
    var vendor: BankCardItem.Vendor? { number.count > 16 ? BankCardItem.Vendor(number) : nil }
    
    var bankCardItem: BankCardItem {
        BankCardItem(name: name, number: number, validityDate: validityDate, validFrom: validFrom, pin: pin)
    }
    
    init(_ bankCardItem: BankCardItem) {
        self.name = bankCardItem.name
        self.number = bankCardItem.number
        self.validityDate = bankCardItem.validityDate
        self.validFrom = bankCardItem.validFrom
        self.pin = bankCardItem.pin
    }
    
    init() {
        self.name = ""
        self.number = ""
        self.validityDate = ""
        self.validFrom = ""
        self.pin = ""
    }
    
}
