#if DEBUG
import Model
import SwiftUI

struct PasswordFieldPreview: PreviewProvider {
    
    static let item = PasswordItem(password: "foo")
    
    static var previews: some View {
        List {
            PasswordField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
