import Localization
import SwiftUI

struct WifiEditView<Model>: View where Model: WifiEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.wifiNetworkName, text: $model.networkName)
            
            Divider()
            
            SecureItemEditSecureField(title: LocalizedString.wifiNetworkPassword, text: $model.networkPassword)
        }
    }
    
}

#if DEBUG
class WifiEditModelStub: WifiEditModelRepresentable {
    
    var networkPassword = ""
    var networkName = ""
    
}

struct WifiEditViewProvider: PreviewProvider {
    
    static let model = WifiEditModelStub()
    
    static var previews: some View {
        WifiEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
