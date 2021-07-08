#if DEBUG
import SwiftUI

struct StoreItemDisplayViewPreview: PreviewProvider {
    
    static let primaryItem = SecureItemField.Value.login(username: "foo", password: "bar", url: "baz")
    
    static var previews: some View {
        NavigationView {
            StoreItemDisplayView("qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now) {
                print("edit")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemDisplayView("foo", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now) {
                print("edit")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
