#if DEBUG
import Model
import SwiftUI

struct LoginFieldPreview: PreviewProvider {
    
    static let item = LoginItem(username: "foo", password: "bar", url: "baz")
    
    static var previews: some View {
        List {
            LoginField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
