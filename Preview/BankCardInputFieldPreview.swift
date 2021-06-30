#if DEBUG
import SwiftUI

struct BankCardInputFieldPreview: PreviewProvider {
    
    static let state = BankCardState()
    
    static var previews: some View {
        List {
            BankCardInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankCardInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
