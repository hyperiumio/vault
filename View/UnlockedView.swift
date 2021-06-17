import SwiftUI

struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var presentedSheet: Sheet?
    @Environment(\.scenePhase) private var scenePhase
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch (model.itemCollation.sections.isEmpty, model.searchText.isEmpty) {
                case (true, true):
                    VStack(spacing: 30) {
                        Text(.emptyVault)
                            .font(.title)
                        
                        Button(.createFirstItem) {
                            presentedSheet = .selectCategory
                        }
                    }
                case (true, false):
                    Text(.noResultsFound)
                        .font(.title)
                case (false, _):
                    List {
                        /*
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
                        }*/
                    }
                    .searchable(text: $model.searchText)
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle(.vault, displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentedSheet = .settings
                    } label: {
                        Image(systemName: .sliderHorizontal3)
                    }
                    
                    Button {
                        model.lockApp(enableBiometricUnlock: false)
                    } label: {
                        Image(systemName: .lock)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presentedSheet = .selectCategory
                    } label: {
                        Image(systemName: .plus)
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
