import Localization
import SwiftUI

#if os(macOS)
struct VaultItemCreatingView<Model>: View where Model: VaultItemCreatingModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(LocalizedString.title, text: $model.title)
                    
                    SecureItemEditView(model: model.primaryItemModel)
                }
                
                Section(header: Text(LocalizedString.additionalItems)) {
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
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(model.primaryItemModel.typeIdentifier)
                        
                        Text(model.primaryItemModel.typeIdentifier.title)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedString.save, action: model.save)
                        .disabled(!model.saveButtonEnabled)
                }
            }
        }
    }
    
}
#endif

#if os(iOS)
struct VaultItemCreatingView<Model>: View where Model: VaultItemCreatingModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(LocalizedString.title, text: $model.title)
                }
                
                Section {
                    SecureItemEditView(model: model.primaryItemModel)
                }
                
                Section(header: Text(LocalizedString.additionalItems)) {
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
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(model.primaryItemModel.typeIdentifier)
                            .foregroundColor(Color(model.primaryItemModel.typeIdentifier))
                        
                        Text(model.primaryItemModel.typeIdentifier.title)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedString.save, action: model.save)
                        .disabled(!model.saveButtonEnabled)
                }
            }
            .environment(\.editMode, .constant(.active))
        }
    }
    
}
#endif

import Store

extension SecureItem.TypeIdentifier {
    
    var title: String {
        switch self {
        case .password:
            return LocalizedString.password
        case .login:
            return LocalizedString.login
        case .file:
            return LocalizedString.file
        case .note:
            return LocalizedString.note
        case .bankCard:
            return LocalizedString.bankCard
        case .wifi:
            return LocalizedString.wifi
        case .bankAccount:
            return LocalizedString.bankAccount
        case .generic:
            return LocalizedString.customField
        }
    }
    
}

#if DEBUG
class VaultItemCreatingModelStub: VaultItemCreatingModelRepresentable {
    
    var title = ""
    var status = VaultItemCreatingModel.Status.none
    var primaryItemModel = SecureItemEditModel(.login)
    var secondaryItemModels = [SecureItemEditModel]()
    var saveButtonEnabled = true
    var primaryItemType: VaultItemCreatingModel.ItemType?
    
    func addSecondaryItem(itemType: VaultItemCreatingModel.ItemType) {}
    func deleteSecondaryItems(at indexSet: IndexSet) {}
    func moveSecondaryItems(from source: IndexSet, to destination: Int) {}
    func save() {}
    func cancel() {}
    
}

struct VaultItemCreatingViewPreview: PreviewProvider {
    
    @StateObject static var model = VaultItemCreatingModelStub()
    
    static var previews: some View {
        NavigationView {
            VaultItemCreatingView(model: model)
        }
    }
    
}
#endif
