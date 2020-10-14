import Localization
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
            VaultItemList(model.itemCollation, searchText: $model.searchText)
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
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            presentedSheet = .selectCategory
                        } label: {
                            Image.plus
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            
            EmptySelection()
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .settings:
                SettingsView(model.settingsModel)
            case .selectCategory:
                SelectCategoryView(action: model.createVaultItem)
            case .createVaultItem(let model):
                CreateVaultItemView(model)
            }
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let name = Text(LocalizedString.loadFailed)
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
    
}

private extension UnlockedView {
    
    struct VaultItemList: View {
        
        let itemCollation: Model.Collation?
        let searchText: Binding<String>
        
        var body: some View {
            if let collation = itemCollation {
                List {
                    SearchBar(text: searchText)
                    
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
                .listStyle(PlainListStyle())
                .navigationBarTitle(LocalizedString.vault, displayMode: .inline)
            } else {
                Text(LocalizedString.emptyVault)
                    .font(.title)
            }
        }
     
        init(_ itemCollation: Model.Collation?, searchText: Binding<String>) {
            self.itemCollation = itemCollation
            self.searchText = searchText
        }
        
    }
    
    struct EmptySelection: View {
        
        var body: some View {
            Text("Nothing Selected")
        }
        
    }
    
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
