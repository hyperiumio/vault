#if DEBUG
import Model
import SwiftUI

struct StoreItemDetailViewPreview: PreviewProvider {
    
    static let storeItemDetailDependency = StoreItemDetailService()
    static let storeItemDetailState = StoreItemDetailState(storeItemInfo: storeItemDetailDependency.storeItem.info, dependency: storeItemDetailDependency)
    
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

extension StoreItemDetailViewPreview {
    
    struct StoreItemDetailService: StoreItemDetailDependency {
        
        var storeItem: StoreItem {
            let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
            let primaryItem = SecureItem.login(loginItem)
            return StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
        }
        
        var storeItemEditDependency: StoreItemEditDependency {
            StoreItemEditService()
        }
        
    }
    
}
#endif
