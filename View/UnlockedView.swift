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
                                    switch item.itemType {
                                    case .password:
                                        Icon(.password)
                                    case .login:
                                        Icon(.login)
                                    case .file:
                                        Icon(.file)
                                    case .note:
                                        Icon(.note)
                                    case .bankCard:
                                        Icon(.bankCard)
                                    case .wifi:
                                        Icon(.wifi)
                                    case .bankAccount:
                                        Icon(.bankAccount)
                                    case .generic:
                                        Icon(.custom)
                                    }
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
                Icon(.plus)
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
            VStack {
                HStack {
                    TextField(LocalizedString.search, text: $model.searchText)
                    
                    CreateVaultItemButton(action: model.createVaultItem) {
                        Icon(.plus)
                    }
                    .sheet(item: $model.newVaultItemModel) { model in
                        VaultItemCreatingView(model: model)
                    }
                }
                .padding()
                
                List {
                    ForEach (model.sections) { section in
                        Section(header: Text(section.title)) {
                            ForEach(section.items) { item in
                                NavigationLink(destination: VaultItemView(model: item.detailModel).navigationBarHidden(false)) {
                                    Label {
                                        Text(item.title)
                                    } icon: {
                                        switch item.itemType {
                                        case .password:
                                            Icon(.password)
                                        case .login:
                                            Icon(.login)
                                        case .file:
                                            Icon(.file)
                                        case .note:
                                            Icon(.note)
                                        case .bankCard:
                                            Icon(.bankCard)
                                        case .wifi:
                                            Icon(.wifi)
                                        case .bankAccount:
                                            Icon(.bankAccount)
                                        case .generic:
                                            Icon(.custom)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
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
