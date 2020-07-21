import Combine
import Store

class BankAccountEditModel: ObservableObject, Identifiable {
    
    @Published var bankName: String
    @Published var accountHolder: String
    @Published var bankCode: String
    @Published var accountNumber: String
    @Published var swiftCode: String
    @Published var iban: String
    @Published var pin: String
    @Published var onlineBankingUrl: String
    
    var isComplete: Bool { !accountNumber.isEmpty }
    
    var secureItem: SecureItem? {
        guard isComplete else { return nil }
            
        let bankAccount = BankAccountItem(bankName: bankName, accountHolder: accountHolder, bankCode: bankCode, accountNumber: accountNumber, swiftCode: swiftCode, iban: iban, pin: pin, onlineBankingUrl: onlineBankingUrl)
        return SecureItem.bankAccount(bankAccount)
    }
    
    init(_ bankAccount: BankAccountItem) {
        self.bankName = bankAccount.bankName
        self.accountHolder = bankAccount.accountHolder
        self.bankCode = bankAccount.bankCode
        self.accountNumber = bankAccount.accountNumber
        self.swiftCode = bankAccount.swiftCode
        self.iban = bankAccount.iban
        self.pin = bankAccount.pin
        self.onlineBankingUrl = bankAccount.onlineBankingUrl
    }
    
    init() {
        self.bankName = ""
        self.accountHolder = ""
        self.bankCode = ""
        self.accountNumber = ""
        self.swiftCode = ""
        self.iban = ""
        self.pin = ""
        self.onlineBankingUrl = ""
    }
    
}
