import Localization
import SwiftUI

struct BankAccountEditView<Model>: View where Model: BankAccountEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.bankAccountName, text: $model.bankName)
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountHolder, text: $model.accountHolder)
            }
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountCode, text: $model.bankCode)
            }
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountNumber, text: $model.accountNumber)
            }
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountSwiftCode, text: $model.swiftCode)
            }
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountIban, text: $model.iban)
            }
            
            Group {
                Divider()
                
                SecureItemEditSecureField(title: LocalizedString.bankAccountPin, text: $model.pin)
            }
            
            Group {
                Divider()
                
                SecureItemEditField(title: LocalizedString.bankAccountOnlineBankingUrl, text: $model.onlineBankingUrl)
            }
        }
    }
    
}

#if DEBUG
class BankAccountEditModelStub: BankAccountEditModelRepresentable {
    
    var bankName = ""
    var accountHolder = ""
    var bankCode = ""
    var accountNumber = ""
    var swiftCode = ""
    var iban = ""
    var pin = ""
    var onlineBankingUrl = ""
    
}

struct BankAccountEditViewProvider: PreviewProvider {
    
    static let model = BankAccountEditModelStub()
    
    static var previews: some View {
        BankAccountEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
