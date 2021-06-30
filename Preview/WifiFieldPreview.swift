#if DEBUG
import SwiftUI

struct WifiFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            WifiField(name: "foo", password: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiField(name: "foo", password: "bar")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
