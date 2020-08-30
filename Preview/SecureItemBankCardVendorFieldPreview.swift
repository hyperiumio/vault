#if DEBUG
import SwiftUI

struct SecureItemBankCardVendorFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SecureItemBankCardVendorField(.masterCard)
            
            SecureItemBankCardVendorField(.visa)
            
            SecureItemBankCardVendorField(.americanExpress)
            
            SecureItemBankCardVendorField(.other)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
