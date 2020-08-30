import Localization
import SwiftUI

struct WifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.wifiNetworkName, text: $model.networkName, isEditable: isEditable)
            
            SecureItemSecureField(LocalizedString.wifiNetworkPassword, text: $model.networkPassword, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
