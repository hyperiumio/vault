import SwiftUI

struct VaultItemCreatingView: View {
    
    @ObservedObject var model: VaultItemCreatingModel
    
    var body: some View {
        return VStack {
            TextField(.title, text: $model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemEditView(secureItemModel: secureItemModel)
                        .padding()
                }
            }
            
            CreateVaultItemButton(action: model.addItem)
            
            HStack {
                Button(.cancel, action: model.cancel)
                Button(.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .disabled(model.isLoading)
        .alert(item: $model.errorMessage) { error in
            return .saveFailed
        }
    }
    
}
