import SwiftUI
#warning("todo")
struct UnlockedView<S>: View where S: UnlockedStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var presentedSheet: Sheet?
    @Environment(\.scenePhase) private var scenePhase
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch (state.itemCollation.sections.isEmpty, state.searchText.isEmpty) {
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
                        ForEach(state.itemCollation.sections) { section in
                            Section {
                                ForEach(section.elements) { state in
                                    NavigationLink(destination: VaultItemReferenceView(state)) {
                                        VaultItemInfoView(state.info.name, description: state.info.description, type: state.info.primaryType)
                                    }
                                }
                            } header: {
                                Text(section.key)
                            }
                        }*/
                    }
                    .searchable(text: $state.searchText)
                    .listStyle(PlainListStyle())
                }
            }
            #if os(iOS)
            .navigationBarTitle(.vault, displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentedSheet = .settings
                    } label: {
                        Image(systemName: .sliderHorizontal3)
                    }
                    
                    Button {
                        state.lockApp(enableBiometricUnlock: false)
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
            #endif
            
            Text(.nothingSelected)
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .settings:
                SettingsView(state.settingsState)
            case .selectCategory:
                SelectCategoryView { selection in
                    switch selection {
                    case .login:
                        state.createLoginItem()
                    case .password:
                        state.createPasswordItem()
                    case .wifi:
                        state.createWifiItem()
                    case .note:
                        state.createNoteItem()
                    case .bankCard:
                        state.createBankCardItem()
                    case .bankAccount:
                        state.createBankAccountItem()
                    case .custom:
                        state.createCustomItem()
                    case .file(data: let data, type: let type):
                        state.createFileItem(data: data, type: type)
                    }
                }
            case .createVaultItem(let state):
                CreateVaultItemView(state)
            }
        }
        .alert(item: $state.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let name = Text(.loadingVaultFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(.deleteFailed)
                return Alert(title: name)
            }
        }
        .onChange(of: state.creationState) { state in
            if let state = state {
                presentedSheet = .createVaultItem(state)
            } else {
                presentedSheet = nil
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .background {
                state.lockApp(enableBiometricUnlock: true)
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
        case createVaultItem(S.VaultItemState)
        
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
