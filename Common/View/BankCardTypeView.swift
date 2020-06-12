import SwiftUI
import Store

struct BankCardTypeView: View {
    
    let vendor: BankCardItem.Vendor
    
    var body: some View {
        switch vendor {
        case .masterCard:
            return Text("MasterCard")
        case .visa:
            return Text("Visa")
        case .americanExpress:
            return Text("American Express")
        case .other:
            return Text("Other")
        }
    }
    
}
