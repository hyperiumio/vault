import Localization
import SwiftUI

struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var presentedSheet: Sheet?
    @Environment(\.scenePhase) private var scenePhase
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Group {
                if let collation = model.itemCollation {
                    List {
                        ForEach(collation.sections) { section in
                            Section {
                                ForEach(section.elements) { model in
                                    NavigationLink(destination: VaultItemReferenceView(model)) {
                                        VaultItemInfoView(model.info.name, description: model.info.description, type: model.info.primaryType)
                                    }
                                }
                            } header: {
                                Text(section.key)
                            }
                        }
                    }
                    .searchBar($model.searchText)
                    .listStyle(PlainListStyle())
                } else {
                    VStack(spacing: 30) {
                        Text(LocalizedString.emptyVault)
                            .font(.title)
                        
                        Button(LocalizedString.createFirstItem) {
                            presentedSheet = .selectCategory
                        }
                        .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fit))
                    }
                }
            }
            .navigationBarTitle(LocalizedString.vault, displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentedSheet = .settings
                    } label: {
                        Image.settings
                    }
                    
                    Button {
                        model.lockApp(enableBiometricUnlock: false)
                    } label: {
                        Image.lock
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presentedSheet = .selectCategory
                    } label: {
                        Image.plus
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Text(LocalizedString.nothingSelected)
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .settings:
                SettingsView(model.settingsModel)
            case .selectCategory:
                SelectCategoryView { selection in
                    switch selection {
                    case .login:
                        model.createLoginItem()
                    case .password:
                        model.createPasswordItem()
                    case .wifi:
                        model.createWifiItem()
                    case .note:
                        model.createNoteItem()
                    case .bankCard:
                        model.createBankCardItem()
                    case .bankAccount:
                        model.createBankAccountItem()
                    case .custom:
                        model.createCustomItem()
                    case .file(data: let data, type: let type):
                        model.createFileItem(data: data, type: type)
                    }
                }
            case .createVaultItem(let model):
                CreateVaultItemView(model)
            }
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let name = Text(LocalizedString.loadingVaultFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(LocalizedString.deleteFailed)
                return Alert(title: name)
            }
        }
        .onChange(of: model.creationModel) { model in
            if let model = model {
                presentedSheet = .createVaultItem(model)
            } else {
                presentedSheet = nil
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .background {
                model.lockApp(enableBiometricUnlock: true)
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        NavigationView {
            Group {
                if let collation = model.itemCollation {
                    VStack(spacing: 5) {
                        SearchBar(text: $model.searchText)
                            .padding(.horizontal, 10)
                        
                        List {
                            ForEach(collation.sections) { section in
                                Section {
                                    ForEach(section.elements) { model in
                                        NavigationLink(destination: VaultItemReferenceView(model)) {
                                            VaultItemInfoView(model.info.name, description: model.info.description, type: model.info.primaryType)
                                        }
                                    }
                                } header: {
                                    Text(section.key)
                                }
                                .collapsible(false)
                            }
                        }
                    }
                } else {
                    Text(LocalizedString.emptyVault)
                        .font(.title)
                }
            }
            .frame(minWidth: 200)
            .toolbar {
                Spacer()
                
                Menu {
                    Button(action: model.createLoginItem) {
                        Image.login
                        
                        Text(LocalizedString.login)
                    }
                    
                    Button(action: model.createPasswordItem) {
                        Image.password
                        
                        Text(LocalizedString.password)
                    }
                    
                    Button(action: model.createWifiItem) {
                        Image.wifi
                        
                        Text(LocalizedString.wifi)
                    }
                    
                    Button(action: model.createNoteItem) {
                        Image.note
                        
                        Text(LocalizedString.note)
                    }
                    
                    Button(action: model.createBankCardItem) {
                        Image.bankCard
                        
                        Text(LocalizedString.bankCard)
                    }
                    
                    Button(action: model.createBankAccountItem) {
                        Image.bankAccount
                        
                        Text(LocalizedString.bankAccount)
                    }
                    
                    Button(action: model.createCustomItem) {
                        Image.custom
                        
                        Text(LocalizedString.custom)
                    }
                } label: {
                    Image.plus
                }
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))
            }
            
            Text(LocalizedString.nothingSelected)
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .settings:
                SettingsView(model.settingsModel)
            case .selectCategory:
                EmptyView()
            case .createVaultItem(let model):
                CreateVaultItemView(model)
            }
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let name = Text(LocalizedString.loadingVaultFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(LocalizedString.deleteFailed)
                return Alert(title: name)
            }
        }
        .onChange(of: model.creationModel) { model in
            if let model = model {
                presentedSheet = .createVaultItem(model)
            } else {
                presentedSheet = nil
            }
        }
    }
    
    #endif
    
}

private extension UnlockedView {
    
    enum Sheet: Identifiable {
        
        case settings
        case selectCategory
        case createVaultItem(Model.VaultItemModel)
        
        var id: String {
            switch self {
            case .settings:
                return "settings"
            case .selectCategory:
                return "selectCategory"
            case .createVaultItem(_):
                return "createVaultItem"
            }
        }
        
    }
    
}

#if os(macOS)
struct SearchBar: View {
    
    let text: Binding<String>
    @State private var isEditing = false
 
    var body: some View {
        HStack(spacing: 5) {
            Image.search.foregroundColor(.secondaryLabel)
            
            TextFieldShim(title: LocalizedString.search, text: text, isSecure: false, textStyle: .body, alignment: .left) {}
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}
#endif
