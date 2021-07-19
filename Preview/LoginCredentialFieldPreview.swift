#if DEBUG
import Model
import SwiftUI

struct LoginCredentialFieldPreview: PreviewProvider {
    
    static let item = LoginCredential(id: UUID(), title: "foo", username: "bar", password: "baz", url: "qux")
    
    static var previews: some View {
        List {
            LoginCredentialField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginCredentialField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
