import Localization
import SwiftUI

struct EditWifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.wifiNetworkName, placeholder: LocalizedString.wifiNetworkName, text: $model.name)
            .keyboardType(.asciiCapable)
        
        SecureItemSecureTextEditField(LocalizedString.wifiNetworkPassword, placeholder: LocalizedString.wifiNetworkPassword, text: $model.password, generatorAvailable: true)
    }
    
}
