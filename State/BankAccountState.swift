import Combine
import Pasteboard
import Persistence

@MainActor
protocol BankAccountStateRepresentable: ObservableObject, Identifiable {
    
    var accountHolder: String { get set }
    var iban: String { get set }
    var bic: String { get set }
    var item: BankAccountItem { get }
    
}

@MainActor
class BankAccountState: BankAccountStateRepresentable {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var item: BankAccountItem {
        let accountHolder = self.accountHolder.isEmpty ? nil : self.accountHolder
        let iban = self.iban.isEmpty ? nil : self.iban
        let bic = self.bic.isEmpty ? nil : self.bic
        
        return BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(_ item: BankAccountItem) {
        self.accountHolder = item.accountHolder ?? ""
        self.iban = item.iban ?? ""
        self.bic = item.bic ?? ""
    }
    
}

#if DEBUG
class BankAccountStateStub: BankAccountStateRepresentable {
    
    @Published var accountHolder = ""
    @Published var iban: String = ""
    @Published var bic: String = ""
    
    var item: BankAccountItem {
        BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
}
#endif
