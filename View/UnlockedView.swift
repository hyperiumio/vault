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
                if model.itemCollation.sections.isEmpty {
                    VStack(spacing: 30) {
                        Text(.emptyVault)
                            .font(.title)
                        
                        Button(.createFirstItem) {
                            presentedSheet = .selectCategory
                        }
                        .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fit))
                    }
                } else {
                    List {
                        ForEach(model.itemCollation.sections) { section in
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
                }
            }
            .navigationBarTitle(.vault, displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentedSheet = .settings
                    } label: {
                        Image(systemName: SFSymbolName.sliderHorizontal3)
                    }
                    
                    Button {
                        model.lockApp(enableBiometricUnlock: false)
                    } label: {
                        Image(systemName: SFSymbolName.lockFill)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presentedSheet = .selectCategory
                    } label: {
                        Image(systemName: SFSymbolName.plus)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Text(.nothingSelected)
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
                let name = Text(.loadingVaultFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(.deleteFailed)
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
                    Text(.emptyVault)
                        .font(.title)
                }
            }
            .frame(minWidth: 200)
            .toolbar {
                Spacer()
                
                Menu {
                    Button(action: model.createLoginItem) {
                        Image(systemName: SFSymbolName.personFill)
                        
                        Text(.login)
                    }
                    
                    Button(action: model.createPasswordItem) {
                        Image(systemName: SFSymbolName.keyFill)
                        
                        Text(.password)
                    }
                    
                    Button(action: model.createWifiItem) {
                        Image(systemName: SFSymbolName.wifi)
                        
                        Text(.wifi)
                    }
                    
                    Button(action: model.createNoteItem) {
                        Image(systemName: SFSymbolName.noteText)
                        
                        Text(.note)
                    }
                    
                    Button(action: model.createBankCardItem) {
                        Image(systemName: SFSymbolName.creditcard)
                        
                        Text(.bankCard)
                    }
                    
                    Button(action: model.createBankAccountItem) {
                        Image(systemName: SFSymbolName.dollarsignCircle)
                        
                        Text(.bankAccount)
                    }
                    
                    Button(action: model.createCustomItem) {
                        Image(systemName: SFSymbolName.scribbleVariable)
                        
                        Text(.custom)
                    }
                } label: {
                    Image(systemName: SFSymbolName.plus)
                }
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))
            }
            
            Text(.nothingSelected)
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
                let name = Text(.loadingVaultFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(.deleteFailed)
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

private extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
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
            Image(systemName: SFSymbolName.magnifyingglass)
                .foregroundColor(.secondaryLabel)
            
            TextFieldShim(title: .localizedSearch, text: text, isSecure: false, textStyle: .body, alignment: .left) {}
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}
#endif
