import SwiftUI

struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemDisplayView(model: secureItemModel)
                        .padding()
                }
            }
            
            Button(.edit, action: model.edit)
        }.frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
