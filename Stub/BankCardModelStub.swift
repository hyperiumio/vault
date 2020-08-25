#if DEBUG
import Foundation

class BankCardModelStub: BankCardModelRepresentable {
    
    @Published var name = ""
    @Published var vendor: BankCardVendor?
    @Published var number = ""
    @Published var expirationDate = Date(timeIntervalSince1970: 0)
    @Published var pin = ""
    
    func copyNameToPasteboard() {}
    func copyNumberToPasteboard() {}
    func copyExpirationDateToPasteboard() {}
    func copyPinToPasteboard() {}
    
}
#endif
