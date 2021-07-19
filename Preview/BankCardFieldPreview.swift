#if DEBUG
import Model
import SwiftUI

struct BankCardFieldPreview: PreviewProvider {
    
    static let item = BankCardItem(name: "foo", number: "bar", expirationDate: .now, pin: "baz")
    
    static var previews: some View {
        List {
            BankCardField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankCardField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
