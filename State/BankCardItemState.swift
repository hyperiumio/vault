import Foundation
import Model

@MainActor
class BankCardItemState: ObservableObject {
    
    @Published var name: String
    @Published var number: String
    @Published var expirationDate: Date
    @Published var pin: String
    
    var item: BankCardItem {
        BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
    init(item: BankCardItem? = nil) {
        self.name = item?.name ?? ""
        self.number = item?.number ?? ""
        self.expirationDate = item?.expirationDate ?? .now
        self.pin = item?.pin ?? ""
    }
    
}
