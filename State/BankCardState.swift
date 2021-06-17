import Combine
import Foundation
import Pasteboard
import Model

@MainActor
protocol BankCardStateRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var number: String { get set }
    var expirationDate: Date { get set }
    var pin: String { get set }
    var item: BankCardItem { get }
    
}

@MainActor
class BankCardState: BankCardStateRepresentable {
    
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
    
    init(_ item: BankCardItem) {
        self.name = item.name ?? ""
        self.number = item.number ?? ""
        self.expirationDate = item.expirationDate ?? Date()
        self.pin = item.pin ?? ""
    }
    
}

#if DEBUG
class BankCardStateStub: BankCardStateRepresentable {
    
    @Published var name = ""
    @Published var number = ""
    @Published var expirationDate = Date()
    @Published var pin = ""
    
    var item: BankCardItem {
        BankCardItem(name: name, number: number, expirationDate: expirationDate, pin: pin)
    }
    
}
#endif
