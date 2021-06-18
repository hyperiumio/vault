import Format
import Pasteboard
import SwiftUI

struct BankAccountView: View {
    
    private let accountHolder: String?
    private let iban: String?
    private let bic: String?
    
    init(accountHolder: String?, iban: String?, bic: String?) {
        self.accountHolder = accountHolder
        self.iban = iban.map(BankAccountNumberFormatStyle.bankAccountNumber.format)
        self.bic = bic
    }
    
    var body: some View {
        Group {
            if let accountHolder = accountHolder {
                Button {
                    Pasteboard.general.string = accountHolder
                } label: {
                    Field(.accountHolder) {
                        Text(accountHolder)
                    }
                }
            }
            
            if let iban = iban {
                Button {
                    Pasteboard.general.string = iban
                } label: {
                    Field(.iban) {
                        Text(iban)
                            .font(.body.monospaced())
                    }
                }
            }
            
            if let bic = bic {
                Button {
                    Pasteboard.general.string = bic
                } label: {
                    Field(.bic) {
                        Text(bic)
                            .font(.body.monospaced())
                    }
                }
            }
        }
        .buttonStyle(.message(.copied))
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
