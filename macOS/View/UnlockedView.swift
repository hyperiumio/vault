import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        return NavigationView {
            VStack {
                TextField(.search, text: $model.searchText)
                
                List(model.items) { item in
                    NavigationLink(destination: DetailView()) {
                        ListItem(title: item.title, iconName: item.iconName)
                            
                    }
                    .contextMenu {
                        Button(.delete) {
                            self.model.requestDelete(id: item.id)
                        }
                    }
                }
                
                CreateVaultItemButton(action: model.createVaultItem)
                    .sheet(item: $model.newVaultItemModel) { model in
                        VaultItemView(model: model)
                    }
            }.frame(minWidth: 200)
        }
        .frame(minWidth: 500, minHeight: 500)
        .onAppear(perform: model.load)
        .alert(item: $model.errorMessage) { errorMessage in
            switch errorMessage {
            case .loadOperationFailed:
                return .loadFailed(retry: model.load)
            case .deleteOperationFailed:
                return .deleteFailed()
            }
            
        }
    }
    
}

struct DetailView: View {
    
    var body: some View {
        return Text("Detail").frame(minWidth:300, maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

extension Alert {
    
    static func loadFailed(retry: @escaping () -> Void) -> Self {
        let loadFail = Text(.loadFailed)
        let retryText = Text(.retry)
        let retry = Alert.Button.default(retryText, action: retry)
        let cancel = Alert.Button.cancel()
        return Alert(title: loadFail, primaryButton: retry, secondaryButton: cancel)
    }
    
    static func deleteFailed() -> Self {
        let deleteFailed = Text(.deleteFailed)
        return Alert(title: deleteFailed)
    }
    
}
