import Localization
import SwiftUI

struct BankCardDisplayView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextDisplayField(LocalizedString.bankCardName, text: model.name)
            
            if let vendor = model.vendor {
                SecureItemDisplayField(LocalizedString.bankCardVendor) {
                    switch vendor {
                    case .masterCard:
                        Text(LocalizedString.mastercard)
                    case .visa:
                        Text(LocalizedString.visa)
                    case .americanExpress:
                        Text(LocalizedString.americanExpress)
                    case .other:
                        Text(LocalizedString.other)
                    }
                }
            }
            
            SecureItemTextDisplayField(LocalizedString.bankCardNumber, text: model.number)
            
            SecureItemDateDisplayField(LocalizedString.bankCardExpirationDate, date: model.expirationDate)
            
            SecureItemSecureTextDisplayField(LocalizedString.bankCardPin, text: model.pin)
        }
    }
}

struct BankCardEditView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextEditField(LocalizedString.bankCardName, text: $model.name)
            
            SecureItemTextEditField(LocalizedString.bankCardNumber, text: $model.number)
            
            SecureItemDateEditField(LocalizedString.bankCardExpirationDate, date: $model.expirationDate)
            
            SecureItemSecureTextEditField(LocalizedString.bankCardPin, text: $model.pin)
        }
    }
}
