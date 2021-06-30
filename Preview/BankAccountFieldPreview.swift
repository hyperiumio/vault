#if DEBUG
import SwiftUI

struct BankAccountFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            BankAccountField(accountHolder: "foo", iban: "bar", bic: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankAccountField(accountHolder: "foo", iban: "bar", bic: "baz")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
