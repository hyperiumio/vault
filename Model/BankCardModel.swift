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
    var item: BankCardItem { get }
    
}

class BankCardModel: BankCardModelRepresentable {
    
    @Published var name: String
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var vendor: BankCardItem.Vendor? {
        number.count > 16 ? BankCardItem.Vendor(number) : nil
    }
    
    var item: BankCardItem {
        let name = self.name.isEmpty ? nil : self.name
        let number = self.number.isEmpty ? nil : self.name
        let pin = self.pin.isEmpty ? nil: self.pin
        
        return BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(_ item: BankCardItem) {
        self.name = item.name ?? ""
        self.number = item.number ?? ""
        self.expirationDate = item.expirationDate ?? Date()
        self.pin = item.pin ?? ""
    }
    
}
