#if DEBUG
import SwiftUI

struct SecureItemBankCardVendorFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SecureItemBankCardVendorField(.masterCard)
                .preferredColorScheme(.light)
            
            SecureItemBankCardVendorField(.masterCard)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
