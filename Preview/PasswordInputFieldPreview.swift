#if DEBUG
import SwiftUI

struct PasswordInputFieldPreview: PreviewProvider {
    
    static let state = PasswordState()
    
    static var previews: some View {
        List {
            PasswordInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
