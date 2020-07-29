import Localization
import SwiftUI

struct WifiDisplayView<Model>: View where Model: WifiDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: LocalizedString.wifiNetworkName, content: model.networkName)
                .onTapGesture(perform: model.copyNetworkNameToPasteboard)
            
            SecureItemDisplaySecureField(title: LocalizedString.wifiNetworkPassword, content: model.networkPassword)
                .onTapGesture(perform: model.copyNetworkPasswordToPasteboard)
        }
    }
    
}

#if DEBUG
class WifiDisplayModelStub: WifiDisplayModelRepresentable {
    
    var networkName = "Office"
    var networkPassword = "123abc"
    
    func copyNetworkNameToPasteboard() {}
    func copyNetworkPasswordToPasteboard() {}
    
}

struct WifiDisplayViewProvider: PreviewProvider {
    
    static let model = WifiDisplayModelStub()
    
    #if os(macOS)
    static var previews: some View {
        List {
            WifiDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            WifiDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
}
#endif
