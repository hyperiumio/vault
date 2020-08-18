import Localization
import SwiftUI

#if os(macOS)
struct VaultItemEditView: View {
    
    @ObservedObject var model: VaultItemEditModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleEditView(secureItemType: model.primaryItemModel.typeIdentifier, title: $model.title)
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
struct VaultItemView: View {
    
    @ObservedObject var model: VaultItemModel
    @State private var isEditable = true
    @State private var isAddItemViewVisible = false
    
    var body: some View {
        List {
            Section {
                VaultItemTitleField(text: $model.title, isEditable: $isEditable)
                
                SecureItemView(model: model.primaryItemModel, isEditable: $isEditable)
                
                ForEach(model.secondaryItemModels) { model in
                    SecureItemView(model: model, isEditable: $isEditable)
                }
                .onDelete(perform: model.deleteSecondaryItems)
                
                Button(LocalizedString.addItem) {
                    isAddItemViewVisible = true
                }
                .foregroundColor(.accentColor)
                .sheet(isPresented: $isAddItemViewVisible) {
                    NavigationView {
                        List(SecureItemType.allCases) { typeIdentifier in
                            Button {
                                model.addSecondaryItem(with: typeIdentifier)
                                isAddItemViewVisible = false
                            } label: {
                                Label {
                                    Text(typeIdentifier.title)
                                        .foregroundColor(.label)
                                } icon: {
                                    Image(typeIdentifier).foregroundColor(Color(typeIdentifier))
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(LocalizedString.addItem)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(LocalizedString.cancel) {
                                    isAddItemViewVisible = false
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SecureItemToolbarItem(type: model.primaryItemModel.typeIdentifier)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save) {
                    model.save()
                }
            }
        }
    }
    
}
#endif
