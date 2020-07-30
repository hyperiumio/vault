import Localization
import SwiftUI

struct BankAccountDisplayView<Model>: View where Model: BankAccountDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemDisplayField(title: LocalizedString.bankAccountName, content: model.bankName)
                .onTapGesture(perform: model.copyBankNameToPasteboard)
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountNumber, content: model.accountNumber)
                    .onTapGesture(perform: model.copyAccountNumberToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountHolder, content: model.accountHolder)
                    .onTapGesture(perform: model.copyAccountHolderToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountCode, content: model.bankCode)
                    .onTapGesture(perform: model.copyBankCodeToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountSwiftCode, content: model.swiftCode)
                    .onTapGesture(perform: model.copySwiftCodeToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountIban, content: model.iban)
                    .onTapGesture(perform: model.copyIbanToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountPin, content: model.pin)
                    .onTapGesture(perform: model.copyPinToPasteboard)
            }
            
            Group {
                Divider()
                
                SecureItemDisplayField(title: LocalizedString.bankAccountOnlineBankingUrl, content: model.onlineBankingUrl)
                    .onTapGesture(perform: model.copyOnlineBankingUrlToPasteboard)
            }
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
    
    static var previews: some View {
        BankAccountDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
}
#endif
