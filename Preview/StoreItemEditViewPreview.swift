#if DEBUG
import Model
import SwiftUI

struct StoreItemEditViewPreview: PreviewProvider {
    
    static let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
    static let primaryItem = SecureItem.login(loginItem)
    static let storeItem = StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
    static let storeItemEditDependency = StoreItemEditDependencyStub()
    static let storeItemEditState = StoreItemEditState(dependency: storeItemEditDependency, editing: storeItem)
    
    static var previews: some View {
        NavigationView {
            StoreItemEditView(storeItemEditState) {
                print("cancel")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemEditView(storeItemEditState) {
                print("cancel")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
