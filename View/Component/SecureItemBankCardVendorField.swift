import Localization
import SwiftUI

struct SecureItemBankCardVendorField: View {
    
    let vendor: BankCardVendor
    
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
    
    init(_ vendor: BankCardVendor) {
        self.vendor = vendor
    }
    
}

#if DEBUG
struct SecureItemBankCardVendorFieldPreviews: PreviewProvider {
    
    static var previews: some View {
        SecureItemBankCardVendorField(.visa)
    }
    
}
#endif
