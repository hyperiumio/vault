import Localization
import SwiftUI

struct WifiDisplayView: View {
    
    private let item: WifiItem
    
    init(_ item: WifiItem) {
        self.item = item
    }
    
    var body: some View {
        if let name = item.name {
            SecureItemTextDisplayField(LocalizedString.wifiNetworkName, text: name)
        }
        
        if let password = item.password {
            SecureItemSecureTextDisplayField(LocalizedString.wifiNetworkPassword, text: password)
        }
    }
    
}
