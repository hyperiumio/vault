import Combine
import Pasteboard
import Store

protocol BankAccountDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var bankName: String { get }
    var accountHolder: String { get }
    var bankCode: String { get }
    var accountNumber: String { get }
    var swiftCode: String { get }
    var iban: String { get }
    var pin: String { get }
    var onlineBankingUrl: String { get }
    
    func copyBankNameToPasteboard()
    func copyAccountHolderToPasteboard()
    func copyBankCodeToPasteboard()
    func copyAccountNumberToPasteboard()
    func copySwiftCodeToPasteboard()
    func copyIbanToPasteboard()
    func copyPinToPasteboard()
    func copyOnlineBankingUrlToPasteboard()
    
}

class BankAccountDisplayModel: BankAccountDisplayModelRepresentable {
    
    var bankName: String { bankAccountItem.bankName }
    var accountHolder: String { bankAccountItem.accountHolder }
    var bankCode: String { bankAccountItem.bankCode }
    var accountNumber: String { bankAccountItem.accountNumber }
    var swiftCode: String { bankAccountItem.swiftCode }
    var iban: String { bankAccountItem.iban }
    var pin: String { bankAccountItem.pin }
    var onlineBankingUrl: String { bankAccountItem.onlineBankingUrl }
    
    private let bankAccountItem: BankAccountItem
    
    init(_ bankAccountItem: BankAccountItem) {
        self.bankAccountItem = bankAccountItem
    }
    
    func copyBankNameToPasteboard() {
        Pasteboard.general.string = bankName
    }
    
    func copyAccountHolderToPasteboard() {
        Pasteboard.general.string = accountHolder
    }
    
    func copyBankCodeToPasteboard() {
        Pasteboard.general.string = bankCode
    }
    
    func copyAccountNumberToPasteboard() {
        Pasteboard.general.string = accountNumber
    }
    
    func copySwiftCodeToPasteboard() {
        Pasteboard.general.string = swiftCode
    }
    
    func copyIbanToPasteboard() {
        Pasteboard.general.string = iban
    }
    
    func copyPinToPasteboard() {
        Pasteboard.general.string = pin
    }
    
    func copyOnlineBankingUrlToPasteboard() {
        Pasteboard.general.string = onlineBankingUrl
    }
    
}
