#if DEBUG
import Model
import SwiftUI

struct StoreItemDetailViewPreview: PreviewProvider {
    
    static let storeItemDetailDependency = StoreItemDetailService()
    static let storeItemDetailState = StoreItemDetailState(storeItemInfo: StoreItemDetailService.storeItem.info, dependency: storeItemDetailDependency)
    
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
    
    actor StoreItemDetailService: StoreItemDetailDependency {
        
        static var storeItem: StoreItem {
            let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
            let primaryItem = SecureItem.login(loginItem)
            return StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
        }
        
        var storeItem: StoreItem {
            get async {
                Self.storeItem
            }
        }
        
        nonisolated func storeItemEditDependency() -> StoreItemEditDependency {
            StoreItemEditService()
        }
        
    }
    
}
#endif
