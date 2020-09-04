#if DEBUG
import SwiftUI

struct SecureItemContainerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SecureItemContainer {
                Text("Title")
                
                Text("Description")
            }
            .preferredColorScheme(.light)
            
            SecureItemContainer {
                Text("Title")
                
                Text("Description")
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
