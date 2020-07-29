import Combine
import Foundation
import Pasteboard
import Store

typealias BankCardVendor = BankCardItem.Vendor

protocol BankCardDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get }
    var vendor: BankCardVendor { get }
    var number: String { get }
    var expirationDate: Date { get }
    var pin: String { get }
    
    func copyNameToPasteboard()
    func copyNumberToPasteboard()
    func copyExpirationDateToPasteboard()
    func copyPinToPasteboard()
    
}

class BankCardDisplayModel: BankCardDisplayModelRepresentable {

    var name: String { bankCardItem.name }
    var vendor: BankCardVendor { bankCardItem.vendor }
    var number: String { bankCardItem.number }
    var expirationDate: Date { bankCardItem.expirationDate }
    var pin: String { bankCardItem.pin }
    
    private let bankCardItem: BankCardItem
    
    init(_ bankCard: BankCardItem) {
        self.bankCardItem = bankCard
    }
    
    func copyNameToPasteboard() {
        Pasteboard.general.string = name
    }
    
    func copyNumberToPasteboard() {
        Pasteboard.general.string = number
    }
    
    func copyExpirationDateToPasteboard() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yy"
        Pasteboard.general.string = formatter.string(from: expirationDate)
    }
    
    func copyPinToPasteboard() {
        Pasteboard.general.string = pin
    }
    
}
