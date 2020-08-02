import Localization
import SwiftUI

#if os(macOS)
struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleView(secureItemType: model.primaryItemModel.typeIdentifier, title: model.title)
            }
            
            Section {
                SecureItemDisplayView(model: model.primaryItemModel)
            }
            
            ForEach(model.secondaryItemModels) { secureItemModel in
                Section {
                    SecureItemDisplayView(model: secureItemModel)
                }
            }
        }
    }
    
}
#endif

#if os(iOS)
struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleView(secureItemType: model.primaryItemModel.typeIdentifier, title: model.title)
            }
            
            Section {
                SecureItemDisplayView(model: model.primaryItemModel)
            }
            
            ForEach(model.secondaryItemModels) { secureItemModel in
                Section {
                    SecureItemDisplayView(model: secureItemModel)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(LocalizedString.edit, action: model.edit)
            }
        }
    }
    
}
#endif
