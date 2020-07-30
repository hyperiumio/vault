import SwiftUI
import Store

struct BankCardVendorField: View {
    
    let title: String
    let vendor: BankCardItem.Vendor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            switch vendor {
            case .masterCard:
                Text("MasterCard")
            case .visa:
                Text("Visa")
            case .americanExpress:
                Text("American Express")
            case .other:
                Text("Other")
            }
        }
        .padding([.top, .bottom])
    }
    
}
