import Localization
import SwiftUI

struct BankAccountDisplayView<Model>: View where Model: BankAccountDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: LocalizedString.bankAccountName, content: model.bankName)
                .onTapGesture(perform: model.copyBankNameToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountNumber, content: model.accountNumber)
                .onTapGesture(perform: model.copyAccountNumberToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountHolder, content: model.accountHolder)
                .onTapGesture(perform: model.copyAccountHolderToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountCode, content: model.bankCode)
                .onTapGesture(perform: model.copyBankCodeToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountSwiftCode, content: model.swiftCode)
                .onTapGesture(perform: model.copySwiftCodeToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountIban, content: model.iban)
                .onTapGesture(perform: model.copyIbanToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountPin, content: model.pin)
                .onTapGesture(perform: model.copyPinToPasteboard)
            
            SecureItemDisplayField(title: LocalizedString.bankAccountOnlineBankingUrl, content: model.onlineBankingUrl)
                .onTapGesture(perform: model.copyOnlineBankingUrlToPasteboard)
        }
    }
    
}

#if DEBUG
class BankAccountDisplayModelStub: BankAccountDisplayModelRepresentable {
    
    var bankName = "Money Bank"
    var accountHolder = "John Doe"
    var bankCode = "12345678"
    var accountNumber = "1234567891"
    var swiftCode = "12345678"
    var iban = "DE91 1000 0000 0123 4567 89"
    var pin = "1234"
    var onlineBankingUrl = "www.moneybank.com"
    
    func copyBankNameToPasteboard() {}
    func copyAccountHolderToPasteboard() {}
    func copyBankCodeToPasteboard() {}
    func copyAccountNumberToPasteboard() {}
    func copySwiftCodeToPasteboard() {}
    func copyIbanToPasteboard() {}
    func copyPinToPasteboard() {}
    func copyOnlineBankingUrlToPasteboard() {}
    
}

struct BankAccountDisplayViewProvider: PreviewProvider {
    
    static let model = BankAccountDisplayModelStub()
    
    #if os(macOS)
    static var previews: some View {
        List {
            BankAccountDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            BankAccountDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
}
#endif
