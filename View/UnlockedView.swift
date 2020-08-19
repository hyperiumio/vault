import Localization
import SwiftUI

#if os(macOS)
struct UnlockedView: View {
    
    @ObservedObject var model: UnlockedModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach (model.sections) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items) { item in
                            NavigationLink(destination: VaultItemView(model: item.detailModel)) {
                                Label {
                                    Text(item.title)
                                } icon: {
                                    Image(item.itemType)
                                        .foregroundColor(Color(item.itemType))
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .toolbar {
            TextField(LocalizedString.search, text: $model.searchText)
                .frame(minWidth: 120)
            
            CreateVaultItemButton(action: model.createVaultItem) {
                Image.plus
                    .imageScale(.large)
            }
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
            List {
                ForEach (model.sections) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items) { item in
                            Label {
                                Text(item.title)
                            } icon: {
                                Image(item.itemType)
                                    .foregroundColor(Color(item.itemType))
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(LocalizedString.vault)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button {
                        settingsPresented = true
                    } label: {
                        Image.settings
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button {
                        model.createVaultItem()
                    } label: {
                        Image.plus
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $model.creationModel) { model in
                VaultItemCreationView(model: model)
            }
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsUnlockedView(model: model.preferencesUnlockedModel)
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let title = Text(LocalizedString.loadFailed)
                return Alert(title: title)
            case .deleteOperationFailed:
                let title = Text(LocalizedString.deleteFailed)
                return Alert(title: title)
            }
        }
    }
    
}
#endif
