#if DEBUG
import Model
import SwiftUI

struct UnlockedViewPreview: PreviewProvider {
    
    static let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
    static let primaryItem = SecureItem.login(loginItem)
    static let storeItem = StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
    static let storeItemEditDependency = StoreItemEditDependencyStub()
    static let storeItemDetailDependency = StoreItemDetailDependencyStub(storeItem: storeItem, storeItemEditDependency: storeItemEditDependency)
    static let storeItemDetailState = [
        StoreItemDetailState(storeItemInfo: storeItem.info, dependency: storeItemDetailDependency)
    ]
    static let nonEmptyCollation = UnlockedState.Collation(from: storeItemDetailState)
    static let emptyCollation = UnlockedState.Collation()
    static let unlockedState = UnlockedState()
    
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
#endif
