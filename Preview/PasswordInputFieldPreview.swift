#if DEBUG
import SwiftUI

struct PasswordInputFieldPreview: PreviewProvider {
    
    static let passwordState = PasswordState()
    
    static var previews: some View {
        List {
            PasswordInputField(passwordState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordInputField(passwordState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
