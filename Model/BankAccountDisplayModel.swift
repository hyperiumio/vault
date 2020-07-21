import Combine
import Store

class BankAccountDisplayModel: ObservableObject, Identifiable {
    
    @Published var pinSecureDisplay = true
    
    var bankName: String { bankAccount.bankName }
    var accountHolder: String { bankAccount.accountHolder }
    var bankCode: String { bankAccount.bankCode }
    var accountNumber: String { bankAccount.accountNumber }
    var swiftCode: String { bankAccount.swiftCode }
    var iban: String { bankAccount.iban }
    var pin: String { bankAccount.pin }
    var onlineBankingUrl: String { bankAccount.onlineBankingUrl }
    
    private let bankAccount: BankAccountItem
    
    init(_ bankAccount: BankAccountItem) {
        self.bankAccount = bankAccount
    }
    
}
