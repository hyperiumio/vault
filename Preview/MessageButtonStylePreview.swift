#if DEBUG
import SwiftUI

struct MessageButtonStylePreview: PreviewProvider {
    
    static var previews: some View {
        List {
            Button("foo") {
                print("action")
            }
            .buttonStyle(.message(.title))
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            Button("foo") {
                print("action")
            }
            .buttonStyle(.message(.title))
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
