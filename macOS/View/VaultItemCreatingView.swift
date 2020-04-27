import SwiftUI

struct VaultItemCreatingView: View {
    
    @ObservedObject var model: VaultItemCreatingModel
    
    var body: some View {
        return VStack {
            TextField(.title, text: $model.title)
            
            Divider()
            
            Form {
                SecureItemEditView(secureItemModel: model.secureItemModel)
            }
            
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
