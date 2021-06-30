import Foundation
import Model

@MainActor
class BankCardState: ObservableObject {
    
    @Published var name: String
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var item: BankCardItem {
        let name = self.name.isEmpty ? nil : self.name
        let number = self.number.isEmpty ? nil : self.number
        let pin = self.pin.isEmpty ? nil: self.pin
        
        return BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(_ item: BankCardItem? = nil) {
        self.name = item?.name ?? ""
        self.number = item?.number ?? ""
        self.expirationDate = item?.expirationDate ?? .now
        self.pin = item?.pin ?? ""
    }
    
}
