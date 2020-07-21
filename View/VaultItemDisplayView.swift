import Localization
import SwiftUI

struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        VStack {
            Text(model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemDisplayView(model: secureItemModel)
                        .padding()
                }
            }
            
            Button(LocalizedString.edit, action: model.edit)
        }
        .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
