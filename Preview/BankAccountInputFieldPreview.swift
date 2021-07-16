#if DEBUG
import SwiftUI

struct BankAccountInputFieldPreview: PreviewProvider {
    
    static let bankAccountState = BankAccountItemState()
    
    static var previews: some View {
        List {
            BankAccountInputField(bankAccountState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankAccountInputField(bankAccountState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
