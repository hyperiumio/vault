import SwiftUI

struct VaultView: View {
    
    @ObservedObject var model: VaultModel
    
    var body: some View {
        return NavigationView {
            VStack {
                TextField(.search, text: $model.searchText)
                
                List(model.items) { item in
                    return NavigationLink(destination: VaultItemView(), tag: item.id, selection: self.$model.selectedItemId) {
                        ListItem(title: item.title, iconName: item.iconName)
                    }
                }
                
                Button(action: model.createItem) {
                    Text(.addItem)
                }
            }.frame(minWidth: 200)
            
            VaultItemView()
        }.frame(minWidth: 500, minHeight: 500)
    }
    
}

struct VaultItemView: View {
    
    var body: some View {
        return Text("Detail")
            .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
