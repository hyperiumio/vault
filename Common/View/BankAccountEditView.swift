import SwiftUI

struct BankAccountEditView: View {
    
    @ObservedObject var model: BankAccountEditModel
    
    var body: some View {
        return VStack {
            TextField(.bankAccountName, text: $model.bankName)
            TextField(.bankAccountHolder, text: $model.accountHolder)
            TextField(.bankAccountCode, text: $model.bankCode)
            TextField(.bankAccountNumber, text: $model.accountNumber)
            TextField(.bankAccountSwiftCode, text: $model.swiftCode)
            TextField(.bankAccountIban, text: $model.iban)
            SecureField(.bankAccountPin, text: $model.pin)
            TextField(.bankAccountOnlineBankingUrl, text: $model.onlineBankingUrl)
        }
    }
    
}
