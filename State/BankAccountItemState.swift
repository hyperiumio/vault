import Foundation
import Model

@MainActor
class BankAccountItemState: ObservableObject {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var item: BankAccountItem {
        BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(item: BankAccountItem? = nil) {
        self.accountHolder = item?.accountHolder ?? ""
        self.iban = item?.iban ?? ""
        self.bic = item?.bic ?? ""
    }
    
}
