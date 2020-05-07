import Combine

class BankAccountDisplayModel: ObservableObject, Identifiable {
    @Published var pinSecureDisplay = true
    
    var bankName: String {
        return bankAccount.bankName
    }
    
    var accountHolder: String {
        return bankAccount.accountHolder
    }
    
    var bankCode: String {
        return bankAccount.bankCode
    }
    
    var accountNumber: String {
        return bankAccount.accountNumber
    }
    
    var swiftCode: String {
        return bankAccount.swiftCode
    }
    
    var iban: String {
        return bankAccount.iban
    }
    
    var pin: String {
        return bankAccount.pin
    }
    
    var onlineBankingUrl: String {
        return bankAccount.onlineBankingUrl
    }
    
    private let bankAccount: BankAccount
    
    init(_ bankAccount: BankAccount) {
        self.bankAccount = bankAccount
    }
}
