import SwiftUI

struct PreferencesView: View {
    
    @ObservedObject var model: PreferencesModel
    
    var body: some View {
        return TabView {
            VaultPreferencesView(model: model.vaultPreferencesModel)
                .tabItem {
                    Text(.vault)
                }
        }
        .frame(width: 200, height: 200)
    }
    
}
