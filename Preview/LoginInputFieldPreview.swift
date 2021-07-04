#if DEBUG
import SwiftUI

struct LoginInputFieldPreview: PreviewProvider {
    
    static let loginState = LoginState()
    
    static var previews: some View {
        List {
            LoginInputField(loginState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginInputField(loginState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
