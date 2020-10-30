import Combine
import Pasteboard
import Store

protocol BankAccountModelRepresentable: ObservableObject, Identifiable {
    
    var accountHolder: String { get set }
    var iban: String { get set }
    var bic: String { get set }
    var bankAccountItem: BankAccountItem { get }
    
}

class BankAccountModel: BankAccountModelRepresentable {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var bankAccountItem: BankAccountItem {
        let accountHolder = self.accountHolder.isEmpty ? nil : self.accountHolder
        let iban = self.iban.isEmpty ? nil : self.iban
        let bic = self.bic.isEmpty ? nil : self.bic
        
        return BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(_ bankAccountItem: BankAccountItem) {
        self.accountHolder = bankAccountItem.accountHolder ?? ""
        self.iban = bankAccountItem.iban ?? ""
        self.bic = bankAccountItem.bic ?? ""
    }
    
}
