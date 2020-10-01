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
                SecureItemDivider()
                
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
            
            SecureItemDivider()
            
            SecureItemTextDisplayField(LocalizedString.bankCardNumber, text: model.number)
            
            SecureItemDivider()
            
            SecureItemDateDisplayField(LocalizedString.bankCardExpirationDate, date: model.expirationDate)
            
            SecureItemDivider()
            
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
            
            SecureItemDivider()
            
            SecureItemTextEditField(LocalizedString.bankCardNumber, text: $model.number)
            
            SecureItemDivider()
            
            SecureItemDateEditField(LocalizedString.bankCardExpirationDate, date: $model.expirationDate)
            
            SecureItemDivider()
            
            SecureItemSecureTextEditField(LocalizedString.bankCardPin, text: $model.pin)
        }
    }
}
