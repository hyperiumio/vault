#if DEBUG
import Model
import SwiftUI

struct WifiFieldPreview: PreviewProvider {
    
    static let item = WifiItem(name: "foo", password: "bar")
    
    static var previews: some View {
        List {
            WifiField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
