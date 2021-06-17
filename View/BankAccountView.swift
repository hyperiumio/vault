import Format
import SwiftUI

struct BankAccountView: View {
    
    private let accountHolder: String?
    private let iban: String?
    private let bic: String?
    
    init(accountHolder: String?, iban: String?, bic: String?) {
        self.accountHolder = accountHolder
        self.iban = iban.map { iban in
            BankAccountNumberFormatter().string(for: NSString(string: iban)) ?? ""
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
            BankAccountView(accountHolder: "foo", iban: "bar", bic: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
