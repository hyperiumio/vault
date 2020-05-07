import SwiftUI

struct UnlockedView: View {
    
    let model: UnlockedModel
    
    var body: some View {
        return VaultItemCollectionView(model: model.vaulItemCollectionModel)
    }
    
}
