import Localization
import SwiftUI

struct BankAccountEditView: View {
    
    @ObservedObject var model: BankAccountEditModel
    
    var body: some View {
        return VStack {
            TextField(LocalizedString.bankAccountName, text: $model.bankName)
            TextField(LocalizedString.bankAccountHolder, text: $model.accountHolder)
            TextField(LocalizedString.bankAccountCode, text: $model.bankCode)
            TextField(LocalizedString.bankAccountNumber, text: $model.accountNumber)
            TextField(LocalizedString.bankAccountSwiftCode, text: $model.swiftCode)
            TextField(LocalizedString.bankAccountIban, text: $model.iban)
            SecureField(LocalizedString.bankAccountPin, text: $model.pin)
            TextField(LocalizedString.bankAccountOnlineBankingUrl, text: $model.onlineBankingUrl)
        }
    }
    
}
