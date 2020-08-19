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
        ScrollView {
            VStack(alignment: .trailing, spacing: 0) {
                VaultItemTitleField(text: $model.title, isEditable: $isEditable)
                
                Divider()
                
                SecureItemView(model: model.primaryItemModel, isEditable: $isEditable)
                
                ForEach(Array(model.secondaryItemModels.enumerated()), id: \.offset) { index, secureItemModel in
                    Divider()
                    
                    HStack(alignment: .top) {
                        SecureItemView(model: secureItemModel, isEditable: $isEditable)
                        
                        Button {
                            model.deleteSecondaryItem(at: index)
                        } label: {
                            Image.trashCircle
                                .renderingMode(.original)
                                .imageScale(.large)
                        }
                        .padding(.vertical)
                    }
                }
                
                Divider()
                
                Button {
                    isAddItemViewVisible = true
                } label: {
                    Image.plusCircle
                        .renderingMode(.original)
                        .imageScale(.large)
                }
                .padding(.vertical)
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
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SecureItemToolbarItem(type: model.primaryItemModel.typeIdentifier)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save) {
                    model.save()
                }
                .disabled(!model.saveButtonEnabled)
            }
        }
    }
    
}
#endif
