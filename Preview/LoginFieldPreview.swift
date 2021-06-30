#if DEBUG
import SwiftUI

struct LoginFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            LoginField(username: "foo", password: "bar", url: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginField(username: "foo", password: "bar", url: "baz")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
