#if DEBUG
import Foundation
import Store

class BankCardModelStub: BankCardModelRepresentable {
    
    @Published var name: String
    @Published var vendor: BankCardItemVendor?
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var bankCardItem: BankCardItem {
        BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(name: String, vendor: BankCardItemVendor?, number: String, expirationDate: Date, pin: String) {
        self.name = name
        self.vendor = vendor
        self.number = number
        self.expirationDate = expirationDate
        self.pin = pin
    }
    
    func copyNameToPasteboard() {}
    func copyNumberToPasteboard() {}
    func copyExpirationDateToPasteboard() {}
    func copyPinToPasteboard() {}
    
}
#endif
