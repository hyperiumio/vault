#if DEBUG
import SwiftUI

struct LoginCredentialFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            LoginCredentialField(title: "foo", username: "bar", url: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginCredentialField(title: "foo", username: "bar", url: "baz")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
