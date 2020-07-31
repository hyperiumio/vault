import Localization
import SwiftUI

#if os(macOS)
struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        List {
            Section {
                VaultItemTitleView(title: model.title)
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
                VaultItemTitleView(title: model.title)
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
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedString.edit, action: model.edit)
            }
            
            ToolbarItem(placement: .principal) {
                HStack {
                    switch model.primaryItemModel.typeIdentifier {
                    case .password:
                        Icon(.password)
                    case .login:
                        Icon(.login)
                    case .file:
                        Icon(.file)
                    case .note:
                        Icon(.note)
                    case .bankCard:
                        Icon(.bankCard)
                    case .wifi:
                        Icon(.wifi)
                    case .bankAccount:
                        Icon(.bankAccount)
                    case .generic:
                        Icon(.custom)
                    }
                    
                    Text(model.primaryItemModel.typeIdentifier.title)
                }
            }
        }
    }
    
}
#endif
