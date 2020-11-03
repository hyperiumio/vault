import Localization
import SwiftUI

struct BankCardView: View {
    
    private let item: BankCardItem
    
    init(_ item: BankCardItem) {
        self.item = item
    }
    
    var body: some View {
        if let name = item.name {
            SecureItemTextDisplayField(LocalizedString.bankCardName, text: name)
        }
        
        if let vendor = item.vendor {
            SecureItemDisplayField(LocalizedString.bankCardVendor) {
                switch vendor {
                case .masterCard:
                    Text(LocalizedString.mastercard)
                case .visa:
                    Text(LocalizedString.visa)
                case .americanExpress:
                    Text(LocalizedString.americanExpress)
                }
            }
        }
        
        if let number = item.number {
            SecureItemTextDisplayField(LocalizedString.bankCardNumber, text: number)
        }
        
        if let expirationDate = item.expirationDate {
            SecureItemDateDisplayField(LocalizedString.bankCardExpirationDate, date: expirationDate)
        }
        
        if let pin = item.pin {
            SecureItemSecureTextDisplayField(LocalizedString.bankCardPin, text: pin)
        }
    }
}
