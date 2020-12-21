import Format
import Store
import SwiftUI

struct BankCardView: View {
    
    private let item: BankCardItem
    
    init(_ item: BankCardItem) {
        self.item = item
    }
    
    var body: some View {
        if let name = item.name {
            SecureItemTextField(.name, text: name)
        }
        
        if let vendor = item.vendor {
            SecureItemField(.vendor) {
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
        
        if let number = item.number {
            SecureItemTextField(.number, text: number, formatter: CreditCardNumberFormatter())
                .font(.system(.body, design: .monospaced))
        }
        
        if let expirationDate = item.expirationDate {
            SecureItemDateField(.expirationDate, date: expirationDate)
        }
        
        if let pin = item.pin {
            SecureItemSecureTextField(.pin, text: pin)
                .font(.system(.body, design: .monospaced))
        }
    }
}

#if DEBUG
struct BankCardViewPreview: PreviewProvider {
    
    static let item = BankCardItem(name: "foo", number: "1234567", expirationDate: Date(), pin: "paz")
    
    static var previews: some View {
        Group {
            List {
                BankCardView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                BankCardView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
