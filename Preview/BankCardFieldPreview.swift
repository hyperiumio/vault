#if DEBUG
import SwiftUI

struct BankCardFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            BankCardField(name: "foo", vendor: .masterCard, number: "bar", expirationDate: .now, pin: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankCardField(name: "foo", vendor: .masterCard, number: "bar", expirationDate: .now, pin: "baz")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
