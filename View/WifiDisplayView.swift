import SwiftUI

struct WifiDisplayView: View {
    
    @ObservedObject var model: WifiDisplayModel
    
    var body: some View {
        VStack {
            Text(model.networkName)
            SecureText(content: model.networkPassword, secureDisplay: $model.networkPasswordSecureDisplay)
        }
    }
    
}
