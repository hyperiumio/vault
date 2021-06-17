import Format
import SwiftUI

struct BankAccountItemView: View {
    
    private let accountHolder: String?
    private let iban: String?
    private let bic: String?
    
    init(accountHolder: String?, iban: String?, bic: String?) {
        self.accountHolder = accountHolder
        self.iban = iban.map { iban in
            BankAccountNumberFormatter().format(iban)
        }
        self.bic = bic
    }
    
    var body: some View {
        if let accountHolder = accountHolder {
            ItemTextField(.accountHolder, text: accountHolder)
        }
        
        if let iban = iban {
            ItemTextField(.iban, text: iban)
                .font(.body.monospaced())
        }
        
        if let bic = bic {
            ItemTextField(.bic, text: bic)
                .font(.body.monospaced())
        }
    }
    
}

#if DEBUG
struct BankAccountViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            BankAccountItemView(accountHolder: "foo", iban: "DE 1234", bic: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
