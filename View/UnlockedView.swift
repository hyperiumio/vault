import Localization
import SwiftUI

#if os(macOS)
struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.items) { item in
                    NavigationLink(destination: VaultItemView(model: item.detailModel)) {
                        Label(item.title, systemImage: item.itemType.systemImage)
                    }
                }
                .onDelete(perform: model.deleteVaultItems)
            }
        }
        .toolbar {
            TextField(LocalizedString.search, text: $model.searchText)
                .frame(minWidth: 120)
            
            CreateVaultItemButton(action: model.createVaultItem)
                .sheet(item: $model.newVaultItemModel) { model in
                    VaultItemCreatingView(model: model)
                }
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let title = Text(LocalizedString.loadFailed)
                let retryText = Text(LocalizedString.retry)
                let primaryButton = Alert.Button.default(retryText, action: model.load)
                let cancel = Alert.Button.cancel()
                return Alert(title: title, primaryButton: primaryButton, secondaryButton: cancel)
            case .deleteOperationFailed:
                let title = Text(LocalizedString.deleteFailed)
                return Alert(title: title)
            }
            
        }
    }
    
}
#endif

#if os(iOS)
struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    @State private var settingsPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField(LocalizedString.search, text: $model.searchText)
                    
                    CreateVaultItemButton(action: model.createVaultItem) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                    .sheet(item: $model.newVaultItemModel) { model in
                        VaultItemCreatingView(model: model)
                    }
                }
                .padding()
                
                List {
                    ForEach(model.items) { item in
                        NavigationLink(destination: VaultItemView(model: item.detailModel).navigationBarHidden(false)) {
                            Label(item.title, systemImage: item.itemType.systemImage)
                        }
                    }
                    .onDelete(perform: model.deleteVaultItems)
                }
                
                Button {
                    settingsPresented = true
                } label: {
                    Label(LocalizedString.settings, systemImage: "gear")
                }
            }
            .navigationBarHidden(true)
            
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsUnlockedView(model: model.preferencesUnlockedModel) {
                settingsPresented = false
            }
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let title = Text(LocalizedString.loadFailed)
                let retryText = Text(LocalizedString.retry)
                let primaryButton = Alert.Button.default(retryText, action: model.load)
                let cancel = Alert.Button.cancel()
                return Alert(title: title, primaryButton: primaryButton, secondaryButton: cancel)
            case .deleteOperationFailed:
                let title = Text(LocalizedString.deleteFailed)
                return Alert(title: title)
            }
            
        }
    }
    
}
#endif

extension UnlockedModel.ItemType {
    
    var systemImage: String {
        switch self {
        case .password:
            return "key.fill"
        case .login:
            return "person.fill"
        case .file:
            return "paperclip"
        case .note:
            return "note.text"
        case .bankCard:
            return "creditcard.fill"
        case .wifi:
            return "wifi"
        case .bankAccount:
            return "dollarsign.circle.fill"
        case .customField:
            return "scribble.variable"
        }
    }
    
}
