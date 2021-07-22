#if DEBUG
import Model
import SwiftUI

struct UnlockedViewPreview: PreviewProvider {
    
    static let storeItemDetailDependency = StoreItemDetailService()
    static let storeItemDetailState = [
        StoreItemDetailState(storeItemInfo: StoreItemDetailService.storeItem.info, dependency: storeItemDetailDependency)
    ]
    static let nonEmptyCollation = UnlockedState.Collation(from: storeItemDetailState)
    static let emptyCollation = UnlockedState.Collation()
    static let unlockedState = UnlockedState(dependency: UnlockedService())
    
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
    
    actor UnlockedService: UnlockedDependency {
        
    }
    
}

#endif
