import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        return NavigationView {
            VStack {
                TextField(.search, text: $model.searchText)
                
                List(model.items) { item in
                    return NavigationLink(destination: Text("Detail")) {
                        ListItem(title: item.title, iconName: item.iconName)
                    }
                }
                
                MenuButton(.addItem) {
                    MenuItem(titleKey: .login) {
                        self.model.createSecureItem(itemType: .login)
                    }
                    
                    MenuItem(titleKey: .password) {
                        self.model.createSecureItem(itemType: .password)
                    }
                    
                    MenuItem(titleKey: .file) {
                        self.model.createSecureItem(itemType: .file)
                    }
                }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
            }.frame(minWidth: 200)
        }
        .frame(minWidth: 500, minHeight: 500)
        .sheet(item: $model.newVaultItemModel) { model in
            VaultItemView(model: model)
        }
    }
    
}
