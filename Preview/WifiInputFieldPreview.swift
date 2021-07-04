#if DEBUG
import SwiftUI

struct WifiInputFieldPreview: PreviewProvider {
    
    static let wifiState = WifiState()
    
    static var previews: some View {
        List {
            WifiInputField(wifiState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiInputField(wifiState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
