import Localization
import SwiftUI

struct WifiDisplayView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextDisplayField(LocalizedString.wifiNetworkName, text: model.networkName)
            
            SecureItemSecureTextDisplayField(LocalizedString.wifiNetworkPassword, text: model.networkPassword)
        }
    }
    
}

struct WifiEditView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextEditField(LocalizedString.wifiNetworkName, text: $model.networkName)
            
            SecureItemSecureTextEditField(LocalizedString.wifiNetworkPassword, text: $model.networkPassword)
        }
    }
    
}
