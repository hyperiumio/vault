#if DEBUG
import Model
import SwiftUI

struct WifiInputFieldPreview: PreviewProvider {
    
    static let state = WifiState()
    
    static var previews: some View {
        List {
            WifiInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
