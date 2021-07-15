#if DEBUG
import Model
import SwiftUI

struct UnlockedViewPreview: PreviewProvider {
    
    static let storeItemDetailDependency = StoreItemDetailService()
    static let storeItemDetailState = [
        StoreItemDetailState(storeItemInfo: storeItemDetailDependency.storeItem.info, dependency: storeItemDetailDependency)
    ]
    static let nonEmptyCollation = UnlockedState.Collation(from: storeItemDetailState)
    static let emptyCollation = UnlockedState.Collation()
    static let unlockedState = UnlockedState(dependency: UnlockedService()) {
        
    }
    
    static var previews: some View {
        UnlockedView(unlockedState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        UnlockedView(unlockedState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)

        NavigationView {
            UnlockedView.Empty {
                print("create")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            UnlockedView.Empty {
                print("create")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            UnlockedView.Value(nonEmptyCollation)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            UnlockedView.Value(nonEmptyCollation)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            UnlockedView.Value(emptyCollation)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            UnlockedView.Value(emptyCollation)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension UnlockedViewPreview {
    
    struct StoreItemEditService: StoreItemEditDependency {
        
        func save(_ storeItem: StoreItem) async throws {}
        func delete(itemID: UUID) async throws {}
        
    }
    
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
    
    struct UnlockedService: UnlockedDependency {
        
    }
    
}

#endif
