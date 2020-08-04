import Localization
import SwiftUI

#if os(macOS)
struct VaultItemEditView: View {
    
    @ObservedObject var model: VaultItemEditModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleEditView(secureItemType: model.primaryItemModel.typeIdentifier, title: $model.title)
            }
            
            Section {
                SecureItemEditView(model: model.primaryItemModel)
            }
            
            Section(header: additionalItemsHeader, footer: dateFooter) {
                ForEach(model.secondaryItemModels) { secureItemModel in
                    SecureItemEditView(model: secureItemModel)
                }
                .onDelete(perform: model.deleteSecondaryItems)
                .onMove(perform: model.moveSecondaryItems)
                
                CreateVaultItemButton(action: model.addSecondaryItem) {
                    Text(LocalizedString.add)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedString.cancel, action: model.cancel)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
    }
    
    private var additionalItemsHeader: some View {
        Text(LocalizedString.additionalItems)
    }
    
    private var dateFooter: some View {
        VaultItemFooter(created: Date(), modified: Date())
    }
    
}
#endif

#if os(iOS)
struct VaultItemEditView: View {
    
    @ObservedObject var model: VaultItemEditModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleEditView(secureItemType: model.primaryItemModel.typeIdentifier, title: $model.title)
            }
            
            Section {
                SecureItemEditView(model: model.primaryItemModel)
            }
            
            Section(header: additionalItemsHeader, footer: dateFooter) {
                ForEach(model.secondaryItemModels) { secureItemModel in
                    SecureItemEditView(model: secureItemModel)
                }
                .onDelete(perform: model.deleteSecondaryItems)
                .onMove(perform: model.moveSecondaryItems)
                
                CreateVaultItemButton(action: model.addSecondaryItem) {
                    Text(LocalizedString.add)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedString.cancel, action: model.cancel)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.editMode, .constant(.active))
    }
    
    private var additionalItemsHeader: some View {
        Text(LocalizedString.additionalItems)
    }
    
    private var dateFooter: some View {
        VaultItemFooter(created: Date(), modified: Date())
    }
    
}
#endif

extension Alert {
    
    static var saveFailed: Self {
        let saveFailed = Text(LocalizedString.saveFailed)
        return Alert(title: saveFailed)
    }
    
}
