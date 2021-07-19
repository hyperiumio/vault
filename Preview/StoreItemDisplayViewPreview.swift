#if DEBUG
import Model
import SwiftUI

struct StoreItemDisplayViewPreview: PreviewProvider {
    
    static let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
    static let primaryItem = SecureItem.login(loginItem)
    
    static var previews: some View {
        NavigationView {
            StoreItemDisplayView("qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now) {
                print("edit")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemDisplayView("qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now) {
                print("edit")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
