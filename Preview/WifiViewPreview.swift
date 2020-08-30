#if DEBUG
import SwiftUI

struct WifiViewPreview: PreviewProvider {
    
    static let model = WifiModelStub(networkName: "", networkPassword: "")
    @State static var isEditable = false
    
    static var previews: some View {
        WifiView(model, isEditable: $isEditable)
    }
    
}
#endif
