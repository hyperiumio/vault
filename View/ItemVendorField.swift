import Format
import SwiftUI

struct ItemVendorField: View {
    
    private let vendor: Vendor
    
    init(vendor: Vendor) {
        self.vendor = vendor
    }
    
    var body: some View {
        ItemField(.vendor) {
            switch vendor {
            case .masterCard:
                Text(.mastercard)
            case .visa:
                Text(.visa)
            case .americanExpress:
                Text(.americanExpress)
            }
        }
    }
}

extension ItemVendorField {
    
    enum Vendor {
        
        case masterCard
        case visa
        case americanExpress
        
    }
    
}

#if DEBUG
struct ItemVendorFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            ItemVendorField(vendor: .masterCard)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
