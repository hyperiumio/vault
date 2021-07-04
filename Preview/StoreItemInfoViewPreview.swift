#if DEBUG
import SwiftUI

struct StoreItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            StoreItemInfoView("foo", description: "bar", type: .login)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            StoreItemInfoView("foo", description: "bar", type: .login)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
