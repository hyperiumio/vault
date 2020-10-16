import Localization
import SwiftUI

struct WifiDisplayView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.wifiNetworkName, text: model.networkName)
        
        SecureItemSecureTextDisplayField(LocalizedString.wifiNetworkPassword, text: model.networkPassword)
    }
    
}

struct WifiEditView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.wifiNetworkName, placeholder: LocalizedString.wifiNetworkName, text: $model.networkName)
            .keyboardType(.asciiCapable)
        
        SecureItemSecureTextEditField(LocalizedString.wifiNetworkPassword, placeholder: LocalizedString.wifiNetworkPassword, text: $model.networkPassword, generatorAvailable: true)
    }
    
}
