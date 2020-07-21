import SwiftUI
import Store

struct BankCardTypeView: View {
    
    let vendor: BankCardItem.Vendor
    
    @ViewBuilder var body: some View {
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
    
}
