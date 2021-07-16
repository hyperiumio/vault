import Foundation
import Model

@MainActor
class BankAccountItemState: ObservableObject {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var item: BankAccountItem {
        let accountHolder = self.accountHolder.isEmpty ? nil : self.accountHolder
        let iban = self.iban.isEmpty ? nil : self.iban
        let bic = self.bic.isEmpty ? nil : self.bic
        
        return BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(_ item: BankAccountItem? = nil) {
        self.accountHolder = item?.accountHolder ?? ""
        self.iban = item?.iban ?? ""
        self.bic = item?.bic ?? ""
    }
    
}
