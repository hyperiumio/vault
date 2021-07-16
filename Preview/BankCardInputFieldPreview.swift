#if DEBUG
import SwiftUI

struct BankCardInputFieldPreview: PreviewProvider {
    
    static let bankCardState = BankCardItemState()
    
    static var previews: some View {
        List {
            BankCardInputField(bankCardState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankCardInputField(bankCardState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
