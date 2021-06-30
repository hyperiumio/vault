#if DEBUG
import SwiftUI

struct PasswordFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            PasswordField(password: "foo")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordField(password: "foo")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
