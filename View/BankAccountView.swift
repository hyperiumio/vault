import Format
import Localization
import SwiftUI

struct BankAccountView: View {
    
    private let item: BankAccountItem
    
    init(_ item: BankAccountItem) {
        self.item = item
    }
    
    var body: some View {
        if let accountHolder = item.accountHolder {
            SecureItemTextField(LocalizedString.accountHolder, text: accountHolder)
        }
        
        if let iban = item.iban {
            SecureItemTextField(LocalizedString.iban, text: iban, formatter: BankAccountNumberFormatter())
                .font(.system(.body, design: .monospaced))
        }
        
        if let bic = item.bic {
            SecureItemTextField(LocalizedString.bic, text: bic)
        }
    }
    
}

#if DEBUG
struct BankAccountViewPreview: PreviewProvider {
    
    static let item = BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz")
    
    static var previews: some View {
        Group {
            List {
                BankAccountView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                BankAccountView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
