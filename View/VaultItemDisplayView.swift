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
            
            if model.secondaryItemModels.isEmpty {
                Section(footer: dateFooter) {
                    SecureItemDisplayView(model: model.primaryItemModel)
                }
            } else {
                Section {
                    SecureItemDisplayView(model: model.primaryItemModel)
                }
                
                Section(footer: dateFooter) {
                    ForEach(model.secondaryItemModels) { secureItemModel in
                        SecureItemDisplayView(model: secureItemModel)
                    }
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
    
    private var dateFooter: some View {
        VaultItemFooter(created: Date(), modified: Date())
    }
}
#endif
