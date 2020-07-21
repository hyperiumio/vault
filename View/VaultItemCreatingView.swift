import Localization
import SwiftUI

struct VaultItemCreatingView: View {
    
    @ObservedObject var model: VaultItemCreatingModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.title, text: $model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemEditView(secureItemModel: secureItemModel)
                        .padding()
                }
            }
            
            CreateVaultItemButton(action: model.addItem)
            
            HStack {
                Button(LocalizedString.cancel, action: model.cancel)
                Button(LocalizedString.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /*
        .disabled(model.isLoading)
        .alert(item: $model.errorMessage) { error in
            return .saveFailed
        }
 */
    }
    
}
