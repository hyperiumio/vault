import Localization
import SwiftUI

struct WifiEditView: View {
    
    @ObservedObject var model: WifiEditModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.wifiNetworkName, text: $model.networkName)
            SecureField(LocalizedString.wifiNetworkPassword, text: $model.networkPassword)
        }
    }
    
}
