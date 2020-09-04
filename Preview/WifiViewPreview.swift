#if DEBUG
import SwiftUI

struct WifiViewPreview: PreviewProvider {
    
    static let model = WifiModelStub(networkName: "", networkPassword: "")
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            WifiView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            WifiView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
