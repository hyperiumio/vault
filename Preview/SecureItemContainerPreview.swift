#if DEBUG
import SwiftUI

struct SecureItemContainerPreview: PreviewProvider {
    
    static var previews: some View {
        SecureItemContainer {
            Text("Title")
            
            Text("Description")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
    
}
#endif
