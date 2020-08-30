import Localization
import SwiftUI

struct SecureItemBankCardVendorField: View {
    
    let vendor: BankCardItemVendor
    
    var body: some View {
        SecureItemField(LocalizedString.bankCardVendor) {
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
    
    init(_ vendor: BankCardItemVendor) {
        self.vendor = vendor
    }
    
}
