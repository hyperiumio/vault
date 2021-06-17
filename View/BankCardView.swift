import Format
import SwiftUI

struct BankCardView: View {
    
    private let name: String?
    private let vendor: ItemVendorField.Vendor?
    private let number: String?
    private let expirationDate: Date?
    private let pin: String?
    
    init(name: String?, vendor: ItemVendorField.Vendor?, number: String?, expirationDate: Date?, pin: String?) {
        self.name = name
        self.vendor = vendor
        self.number = number.map { number in
            CreditCardNumberFormatter().string(for: NSString(string: number)) ?? ""
        }
        self.expirationDate = expirationDate
        self.pin = pin
    }
    
    var body: some View {
        if let name = name {
            ItemTextField(.name, text: name)
        }
        
        if let vendor = vendor {
            ItemVendorField(vendor: vendor)
        }
        
        if let number = number {
            ItemTextField(.number, text: number)
                .font(.body.monospaced())
        }
        
        if let expirationDate = expirationDate {
            ItemDateField(.expirationDate, date: expirationDate)
        }
        
        if let pin = pin {
            ItemSecureField(.pin, text: pin)
                .font(.body.monospaced())
        }
    }
}

#if DEBUG
struct BankCardViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            BankCardView(name: "foo", vendor: .masterCard, number: "1234567", expirationDate: Date(), pin: "paz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
