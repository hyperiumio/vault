import SwiftUI

struct BankCardTypeView: View {
    let bankCardType: BankCard.BankCardType
    
    var body: some View {
        switch bankCardType {
            
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
