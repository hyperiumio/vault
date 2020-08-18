import Combine
import Pasteboard
import Store

protocol BankAccountModelRepresentable: ObservableObject, Identifiable {
    
    var accountHolder: String { get set }
    var iban: String { get set }
    var bic: String { get set }
    
    func copyAccountHolderToPasteboard()
    func copyIbanToPasteboard()
    func copyBicToPasteboard()
    
}

class BankAccountModel: BankAccountModelRepresentable {
    
    @Published var accountHolder: String
    @Published var iban: String
    @Published var bic: String
    
    var bankAccountItem: BankAccountItem {
        BankAccountItem(accountHolder: accountHolder, iban: iban, bic: bic)
    }
    
    init(_ bankAccountItem: BankAccountItem) {
        self.accountHolder = bankAccountItem.accountHolder
        self.iban = bankAccountItem.iban
        self.bic = bankAccountItem.bic
    }
    
    init() {
        self.accountHolder = ""
        self.iban = ""
        self.bic = ""
    }
    
    func copyAccountHolderToPasteboard() {
        Pasteboard.general.string = accountHolder
    }
    
    func copyIbanToPasteboard() {
        Pasteboard.general.string = iban
    }
    
    func copyBicToPasteboard() {
        Pasteboard.general.string = bic
    }
    
}
