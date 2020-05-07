import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        return TabView {
            VaultItemCollectionView(model: model.vaulItemCollectionModel)
                .tabItem {
                    Text(.vault)
                }
            
            PreferencesView(model: model.preferencesModel)
                .tabItem {
                    Text("foo")
                }
        }
    }
    
}
