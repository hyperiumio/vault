import Combine
import Foundation
import Store

protocol BankCardEditModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var number: String { get set }
    var expirationDate: Date { get set }
    var pin: String { get set }
    var vendor: BankCardVendor? { get }
    
}

class BankCardEditModel: BankCardEditModelRepresentable {
    
    @Published var name: String
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var vendor: BankCardItem.Vendor? {
        number.count > 16 ? BankCardItem.Vendor(number) : nil
    }
    
    var bankCardItem: BankCardItem {
        BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(_ bankCardItem: BankCardItem) {
        self.name = bankCardItem.name
        self.number = bankCardItem.number
        self.expirationDate = bankCardItem.expirationDate
        self.pin = bankCardItem.pin
    }
    
    init() {
        self.name = ""
        self.number = ""
        self.expirationDate = Date()
        self.pin = ""
    }
    
}
