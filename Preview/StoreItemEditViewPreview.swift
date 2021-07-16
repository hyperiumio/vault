#if DEBUG
import Model
import SwiftUI

struct StoreItemEditViewPreview: PreviewProvider {
    
    static let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
    static let primaryItem = SecureItem.login(loginItem)
    static let storeItem = StoreItem(id: UUID(), name: "qux", primaryItem: primaryItem, secondaryItems: [], created: .distantPast, modified: .now)
    static let storeItemEditDependency = StoreItemEditService()
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

extension StoreItemEditViewPreview {
    
    struct PasswordGeneratorService: PasswordGeneratorDependency {
        
        func password(length: Int, digit: Bool, symbol: Bool) async -> String {
            "foo"
        }
        
    }
    
    struct PasswordService: PasswordItemDependency {
        
        var passwordGeneratorDependency: PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    struct LoginService: LoginItemDependency {
        
        var passwordGeneratorDependency: PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    struct WifiService: WifiItemDependency {
        
        var passwordGeneratorDependency: PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    struct StoreItemEditService: StoreItemEditDependency {
        
        var passwordDependency: PasswordItemDependency {
            PasswordService()
        }
        
        var loginDependency: LoginItemDependency {
            LoginService()
        }
        
        var wifiDependency: WifiItemDependency {
            WifiService()
        }
        
        func save(_ storeItem: StoreItem) async throws {}
        func delete(itemID: UUID) async throws {}
        
    }
    
}
#endif
