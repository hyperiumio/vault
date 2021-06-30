#if DEBUG
import SwiftUI

struct LoginInputFieldPreview: PreviewProvider {
    
    static let state = LoginState()
    
    static var previews: some View {
        List {
            LoginInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
