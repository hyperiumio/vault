import Localization
import SwiftUI

struct WifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(title: LocalizedString.wifiNetworkName, text: $model.networkName, isEditable: isEditable)
            
            SecureItemSecureField(title: LocalizedString.wifiNetworkPassword, text: $model.networkPassword, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class WifiModelStub: WifiModelRepresentable {
    
    var networkName = "Office"
    var networkPassword = "123abc"
    
    func copyNetworkNameToPasteboard() {}
    func copyNetworkPasswordToPasteboard() {}
    
}

struct WifiViewPreviewProvider: PreviewProvider {
    
    static let model = WifiModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        WifiView(model: model, isEditable: $isEditable)
    }
    
}
#endif
