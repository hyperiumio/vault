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
    
    actor PasswordGeneratorService: PasswordGeneratorDependency {
        
        func password(length: Int, digit: Bool, symbol: Bool) async -> String {
            "foo"
        }
        
    }
    
    actor PasswordService: PasswordItemDependency {
        
        nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    actor LoginService: LoginItemDependency {
        
        nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    actor WifiService: WifiItemDependency {
        
        nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    actor StoreItemEditService: StoreItemEditDependency {
        
        func save(_ storeItem: StoreItem) async throws {}
        func delete(itemID: UUID) async throws {}
        
        nonisolated func passwordDependency() -> PasswordItemDependency {
            PasswordService()
        }
        
        nonisolated func loginDependency() -> LoginItemDependency {
            LoginService()
        }
        
        nonisolated func wifiDependency() -> WifiItemDependency {
            WifiService()
        }
        
    }
    
}
#endif
