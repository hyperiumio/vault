import SwiftUI

struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.title)
            
            Divider()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemDisplayView(model: secureItemModel)
                }
            }
            
            Button(.edit, action: model.edit)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
