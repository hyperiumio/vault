import Format
import Persistence
import SwiftUI

#warning("Todo")
struct BankAccountView: View {
    
    private let item: BankAccountItem
    
    init(_ item: BankAccountItem) {
        self.item = item
    }
    
    var body: some View {
        if let accountHolder = item.accountHolder {
            SecureItemTextField(.accountHolder, text: accountHolder)
        }
        
        if let iban = item.iban {
            SecureItemTextField(.iban, text: iban, formatter: BankAccountNumberFormatter())
                .font(.system(.body, design: .monospaced))
        }
        
        if let bic = item.bic {
            SecureItemTextField(.bic, text: bic)
        }
    }
    
}

#if DEBUG
struct BankAccountViewPreview: PreviewProvider {
    
    static let item = BankAccountItem(accountHolder: "foo", iban: "bar", bic: "baz")
    
    static var previews: some View {
        List {
            BankAccountView(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
