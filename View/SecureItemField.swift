import SwiftUI
import UniformTypeIdentifiers

struct SecureItemField: View {
    
    private let value: Value
    
    init(_ value: Value) {
        self.value = value
    }
    
    var body: some View {
        switch value {
        case .login(let username, let password, let url):
            LoginField(username: username, password: password, url: url)
        case .password(let password):
            PasswordField(password: password)
        case .file(let data, let type):
            if let data = data, let type = type {
                FileField(data: data, type: type)
            } else {
                FileField()
            }
        case .note(let text):
            NoteField(text: text)
        case .bankCard(let name, let vendor, let number, let expirationDate, let pin):
            BankCardField(name: name, vendor: vendor, number: number, expirationDate: expirationDate, pin: pin)
        case .wifi(let name, let password):
            WifiField(name: name, password: password)
        case .bankAccount(let accountHolder, let iban, let bic):
            BankAccountField(accountHolder: accountHolder, iban: iban, bic: bic)
        case .custom(let description, let value):
            CustomField(description: description, value: value)
        }
    }
    
}

extension SecureItemField {
    
    enum Value {
        
        case login(username: String?, password: String?, url: String?)
        case password(password: String?)
        case file(data: Data?, type: UTType?)
        case note(text: String?)
        case bankCard(name: String?, vendor: Vendor?, number: String?, expirationDate: Date?, pin: String?)
        case wifi(name: String?, password: String?)
        case bankAccount(accountHolder: String?, iban: String?, bic: String?)
        case custom(description: String?, value: String?)
        
    }
    
}
