import SwiftUI

struct VaultItemView: View {
    
    @ObservedObject var model: VaultItemModel
    
    var body: some View {
        return VStack {
            TextField(.title, text: $model.title)
            
            Divider()
            
            Form {
                VaultItemElementView(secureItem: model.secureItem)
            }
            
            HStack {
                Button(.cancel, action: model.cancel)
                Button(.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
    }
    
}
