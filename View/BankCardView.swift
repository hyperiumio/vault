import Localization
import SwiftUI

#if os(iOS)
struct BankCardView: View {
    
    private let item: BankCardItem
    
    init(_ item: BankCardItem) {
        self.item = item
    }
    
    var body: some View {
        if let name = item.name {
            SecureItemTextField(LocalizedString.name, text: name)
        }
        
        if let vendor = item.vendor {
            SecureItemField(LocalizedString.vendor) {
                switch vendor {
                case .masterCard:
                    Text(LocalizedString.mastercard)
                case .visa:
                    Text(LocalizedString.visa)
                case .americanExpress:
                    Text(LocalizedString.americanExpress)
                }
            }
        }
        
        if let number = item.number {
            SecureItemTextField(LocalizedString.number, text: number)
        }
        
        if let expirationDate = item.expirationDate {
            SecureItemDateField(LocalizedString.expirationDate, date: expirationDate)
        }
        
        if let pin = item.pin {
            SecureItemSecureTextField(LocalizedString.pin, text: pin)
        }
    }
}
#endif

#if os(iOS) && DEBUG
struct BankCardViewPreview: PreviewProvider {
    
    static let item = BankCardItem(name: "foo", number: "bar", expirationDate: Date(), pin: "paz")
    
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
