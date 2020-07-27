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
    
    var bankAccountItem: BankAccountItem {
        BankAccountItem(bankName: bankName, accountHolder: accountHolder, bankCode: bankCode, accountNumber: accountNumber, swiftCode: swiftCode, iban: iban, pin: pin, onlineBankingUrl: onlineBankingUrl)
    }
    
    init(_ bankAccountItem: BankAccountItem) {
        self.bankName = bankAccountItem.bankName
        self.accountHolder = bankAccountItem.accountHolder
        self.bankCode = bankAccountItem.bankCode
        self.accountNumber = bankAccountItem.accountNumber
        self.swiftCode = bankAccountItem.swiftCode
        self.iban = bankAccountItem.iban
        self.pin = bankAccountItem.pin
        self.onlineBankingUrl = bankAccountItem.onlineBankingUrl
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
