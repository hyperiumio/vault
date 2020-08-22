import Localization
import SwiftUI

#if os(macOS)
struct VaultItemCreationView<Model>: View where Model: VaultItemCreationModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            List(model.detailModels) { detailModel in
                NavigationLink(destination: VaultItemView(model: detailModel)) {
                    Label {
                        Text(detailModel.primaryItemModel.typeIdentifier.name)
                            .foregroundColor(.label)
                    } icon: {
                        Image(detailModel.primaryItemModel.typeIdentifier).foregroundColor(Color(detailModel.primaryItemModel.typeIdentifier))
                    }
                }
            }
            .listStyle(PlainListStyle())
          //  .navigationBarTitleDisplayMode(.inline)
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
#endif

#if os(iOS)
struct VaultItemCreationView<Model>: View where Model: VaultItemCreationModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            List(model.detailModels) { detailModel in
                NavigationLink(destination: VaultItemView(model: detailModel)) {
                    Label {
                        Text(detailModel.primaryItemModel.typeIdentifier.name)
                            .foregroundColor(.label)
                    } icon: {
                        Image(detailModel.primaryItemModel.typeIdentifier).foregroundColor(Color(detailModel.primaryItemModel.typeIdentifier))
                    }
                }
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
#endif

import Store

extension SecureItem.TypeIdentifier {
    
    var name: String {
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
