import SwiftUI

struct WifiEditView: View {
    
    @ObservedObject var model: WifiEditModel
    
    var body: some View {
        return VStack {
            TextField(.wifiNetworkName, text: $model.networkName)
            SecureField(.wifiNetworkPassword, text: $model.networkPassword)
        }
    }
    
}
