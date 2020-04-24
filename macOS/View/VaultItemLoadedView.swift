import SwiftUI

struct VaultItemLoadedView: View {
    
    @ObservedObject var model: VaultItemLoadedModel
    
    var body: some View {
        return VStack {
            Text(model.title)
            
            Divider()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemDisplayView(model: secureItemModel)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
