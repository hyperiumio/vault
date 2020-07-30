import Localization
import SwiftUI

struct WifiDisplayView<Model>: View where Model: WifiDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemDisplayField(title: LocalizedString.wifiNetworkName, content: model.networkName)
                .onTapGesture(perform: model.copyNetworkNameToPasteboard)
            
            Divider()
            
            SecureItemDisplaySecureField(title: LocalizedString.wifiNetworkPassword, content: model.networkPassword)
                .onTapGesture(perform: model.copyNetworkPasswordToPasteboard)
        }
    }
    
}

#if DEBUG
class WifiDisplayModelStub: WifiDisplayModelRepresentable {
    
    var networkName = "Office"
    var networkPassword = "123abc"
    
    func copyNetworkNameToPasteboard() {}
    func copyNetworkPasswordToPasteboard() {}
    
}

struct WifiDisplayViewProvider: PreviewProvider {
    
    static let model = WifiDisplayModelStub()
    
    static var previews: some View {
        WifiDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
