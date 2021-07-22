#if DEBUG
import SwiftUI

struct MessageButtonStylePreview: PreviewProvider {
    
    static var previews: some View {
        List {
            Button("foo") {
                print("action")
            }
            .buttonStyle(.message("bar"))
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            Button("foo") {
                print("action")
            }
            .buttonStyle(.message("bar"))
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
