#if DEBUG
import Combine
import Store

class BankAccountModelStub: BankAccountModelRepresentable {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var bankAccountItem: BankAccountItem {
        BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(accountHolder: String, iban: String, bic: String) {
        self.accountHolder = accountHolder
        self.iban = iban
        self.bic = bic
    }
    
}
#endif
