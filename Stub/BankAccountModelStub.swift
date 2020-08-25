#if DEBUG
import Combine

class BankAccountModelStub: BankAccountModelRepresentable {
    
    @Published var accountHolder = ""
    @Published var iban = ""
    @Published var bic = ""
    
    func copyAccountHolderToPasteboard() {}
    func copyIbanToPasteboard() {}
    func copyBicToPasteboard() {}
    
}
#endif
