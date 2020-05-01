import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        let createButton = CreateVaultItemButton(action: model.createVaultItem)
            .sheet(item: $model.newVaultItemModel) { model in
                VaultItemCreatingView(model: model)
            }
        
        return NavigationView {
            VStack {
                TextField(.search, text: $model.searchText)
                
                List(model.items) { item in
                    NavigationLink(destination: VaultItemView(model: item.detailModel)) {
                        ListItem(title: item.title, iconName: item.iconName)
                            
                    }
                }
            }
            .navigationBarItems(trailing: createButton)
        }
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
