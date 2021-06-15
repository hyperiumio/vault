import Persistence
import SwiftUI

#warning("Todo")
struct WifiView: View {
    
    private let item: WifiItem
    
    init(_ item: WifiItem) {
        self.item = item
    }
    
    var body: some View {
        if let name = item.name {
            SecureItemTextField(.name, text: name)
        }
        
        if let password = item.password {
            SecureItemSecureTextField(.password, text: password)
        }
    }
    
}

#if DEBUG
struct WifiViewPreview: PreviewProvider {
    
    static let item = WifiItem(name: "foo", password: "bar")
    
    static var previews: some View {
        Group {
            List {
                WifiView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                WifiView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
