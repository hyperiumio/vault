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
struct VaultItemCreatingSelectionView<Model>: View where Model: VaultItemCreatingSelectionModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                VaultItemButton(LocalizedString.login, icon: .login, color: .appBlue, action: model.createLogin)
                
                VaultItemButton(LocalizedString.password, icon: .password, color: .appGray, action: model.createPassword)
                
                VaultItemButton(LocalizedString.file, icon: .file, color: .appPink, action: model.createFile)
                
                VaultItemButton(LocalizedString.note, icon: .note, color: .appYellow, action: model.createNote)
                
                VaultItemButton(LocalizedString.bankCard, icon: .bankCard, color: .appPurple, action: model.createBankCard)
                
                VaultItemButton(LocalizedString.wifi, icon: .wifi, color: .appTeal, action: model.createWifi)
                
                VaultItemButton(LocalizedString.bankAccount, icon: .bankAccount, color: .appGreen, action: model.createBankAccount)
                
                VaultItemButton(LocalizedString.customItem, icon: .custom, color: .appRed, action: model.createCustomItem)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(LocalizedString.select)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
}

private struct VaultItemButton: View {
    
    let title: String
    let icon: Image
    let color: Color
    let action: () -> Void
    
    init(_ title: String, icon: Image, color: Color, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
                    .foregroundColor(.label)
            } icon: {
                icon.foregroundColor(color)
            }
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
        case .custom:
            return LocalizedString.customItem
        }
    }
    
}

#if DEBUG
/*
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
 */
#endif
