#if DEBUG
import Model
import SwiftUI

struct StoreItemDetailViewPreview: PreviewProvider {
    
    static let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
    static let primaryItem = SecureItem.login(loginItem)
    static let storeItem = StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
    static let storeItemEditDependency = StoreItemEditDependencyStub()
    static let storeItemDetailDependency = StoreItemDetailDependencyStub(storeItem: storeItem, storeItemEditDependency: storeItemEditDependency)
    static let storeItemDetailState = StoreItemDetailState(storeItemInfo: storeItem.info, dependency: storeItemDetailDependency)
    
    static var previews: some View {
        NavigationView {
            StoreItemDetailView(storeItemDetailState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemDetailView(storeItemDetailState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
