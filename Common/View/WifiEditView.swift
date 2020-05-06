import SwiftUI

struct WifiEditView: View {
    
    @ObservedObject var model: WifiEditModel
    
    var body: some View {
        return VStack {
            TextField(.wifiNetworkName, text: $model.networkName)
            TextField(.wifiNetworkPassword, text: $model.networkPassword)
        }
    }
    
}
