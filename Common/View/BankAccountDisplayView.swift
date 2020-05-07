import SwiftUI

struct BankAccountDisplayView: View {
    
    @ObservedObject var model: BankAccountDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.bankName)
            Text(model.accountNumber)
            Text(model.accountHolder)
            Text(model.bankCode)
            Text(model.swiftCode)
            Text(model.iban)
            Text(model.pin)
            Text(model.onlineBankingUrl)
            SecureText(content: model.pin, secureDisplay: $model.pinSecureDisplay)
        }
    }
    
}
