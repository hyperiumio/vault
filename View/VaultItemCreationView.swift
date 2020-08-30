import Localization
import SwiftUI

#if os(macOS)

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
                        Text(detailModel.primaryItemModel.secureItem.typeIdentifier.name)
                            .foregroundColor(.label)
                    } icon: {
                        Image(detailModel.primaryItemModel.secureItem.typeIdentifier).foregroundColor(Color(detailModel.primaryItemModel.secureItem.typeIdentifier))
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
