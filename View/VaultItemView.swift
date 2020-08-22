import Localization
import SwiftUI

#if os(macOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var isEditable = true
    @State private var isAddItemViewVisible = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 0) {
                VaultItemTitleField(text: $model.name, isEditable: $isEditable)
                
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
                                    Text(typeIdentifier.name)
                                        .foregroundColor(.label)
                                } icon: {
                                    Image(typeIdentifier).foregroundColor(Color(typeIdentifier))
                                }
                            }
                        }
                      //  .listStyle(PlainListStyle())
                      //  .navigationBarTitleDisplayMode(.inline)
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
  //      .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SecureItemToolbarItem(type: model.primaryItemModel.typeIdentifier)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save) {
                    model.save()
                }
                .disabled(model.status != .loading && !model.name.isEmpty)
            }
        }
    }
    
}
#endif

#if os(iOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var isEditable = true
    @State private var isAddItemViewVisible = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 0) {
                VaultItemTitleField(text: $model.name, isEditable: $isEditable)
                
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
                                    Text(typeIdentifier.name)
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
                .disabled(model.status != .loading && !model.name.isEmpty)
            }
        }
    }
    
}
#endif
