import Combine

class BankCardEditModel: ObservableObject, Identifiable {
    
    @Published var name: String
    
    @Published var type: String
    
    @Published var number: String
    
    @Published var validityDate: String
    
    @Published var validFrom: String
    
    @Published var note: String
    
    @Published var pin: String
    
    var isComplete: Bool {
        return !number.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !name.isEmpty, !type.isEmpty, !number.isEmpty, !validityDate.isEmpty, !validFrom.isEmpty, !note.isEmpty, !pin.isEmpty else {
            return nil
        }
            
        let bankCard = BankCard(name: name, type: type, number: number, validityDate: validityDate, validFrom: validFrom, note: note, pin: pin)
        return SecureItem.bankCard(bankCard)
    }
    
    init(_ bankCard: BankCard? = nil) {
        self.name = bankCard?.name ?? ""
        self.type = bankCard?.type ?? ""
        self.number = bankCard?.number ?? ""
        self.validityDate = bankCard?.validityDate ?? ""
        self.validFrom = bankCard?.validFrom ?? ""
        self.note = bankCard?.note ?? ""
        self.pin = bankCard?.pin ?? ""
    }
    
}
