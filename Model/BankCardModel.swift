import Combine
import Foundation
import Pasteboard
import Store

protocol BankCardModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var number: String { get set }
    var expirationDate: Date { get set }
    var pin: String { get set }
    var vendor: BankCardItemVendor? { get }
    var bankCardItem: BankCardItem { get }
    
}

class BankCardModel: BankCardModelRepresentable {
    
    @Published var name: String
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var vendor: BankCardItem.Vendor? {
        number.count > 16 ? BankCardItem.Vendor(number) : nil
    }
    
    var bankCardItem: BankCardItem {
        let name = self.name.isEmpty ? nil : self.name
        let number = self.number.isEmpty ? nil : self.name
        let pin = self.pin.isEmpty ? nil: self.pin
        
        return BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(_ bankCardItem: BankCardItem) {
        self.name = bankCardItem.name ?? ""
        self.number = bankCardItem.number ?? ""
        self.expirationDate = bankCardItem.expirationDate ?? Date()
        self.pin = bankCardItem.pin ?? ""
    }
    
}
