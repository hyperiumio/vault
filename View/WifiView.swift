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
        SecureItemTextEditField(LocalizedString.wifiNetworkName, text: $model.networkName)
        
        VStack(spacing: 0) {
            SecureItemSecureTextEditField(LocalizedString.password, text: $model.networkPassword)
            
            PasswordGeneratorView(action: model.generatePassword)
                .padding()
        }
    }
    
}
