import SwiftUI

struct VaultItemView: View {
    
    @ObservedObject var model: VaultItemModel
    
    var body: some View {
        return VStack {
            TextField(.title, text: $model.title)
            
            Divider()
            
            Form {
                SecureItemView(secureItemModel: model.secureItemModel)
            }
            
            HStack {
                Button(.cancel, action: model.cancel)
                Button(.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }.disabled(model.isLoading)
    }
    
}
