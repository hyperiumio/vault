import Configuration
import SwiftUI
import Shim
import UniformTypeIdentifiers

struct StoreSettingsView: View {
    
    @ObservedObject private var state: StoreSettingsState
    private let isAlertPresented: Binding<Bool>
    private let sheet: Binding<Sheet?>

    init(_ state: StoreSettingsState) {
        self.state = state
        
        self.isAlertPresented = Binding {
            switch state.status {
            case .failure, .action(.confirmDeleteAllData):
                return true
            case .input, .processing, .action:
                return false
            }
        } set: { isPresented in
            state.present(nil)
        }
        
        self.sheet = Binding {
            if case let .action(action) = state.status {
                return Sheet(action)
            } else {
                return nil
            }
        } set: { sheet in
            let action = sheet.map { sheet in
                StoreSettingsState.Action(sheet)
            }
            state.present(action)
        }
    }
    
    private var alert: Alert? {
        switch state.status {
        case let .failure(failure):
            return Alert(failure)
        case .action(.confirmDeleteAllData):
            return .confirmDeleteAllData
        case .input, .processing, .action:
            return nil
        }
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(.storeInfos) {
                    StoreInfoSettingsView(state.storeInfoSettingsState)
                }
            }
            
            Section {
                Button(.exportItems) {
                    state.exportItems()
                }
                
                Button(.importItems) {
                    state.present(.importItems)
                }
            }
            
            Section {
                Button(.createBackup) {
                    state.createBackup()
                }
                
                Button(.restoreBackup) {
                    state.present(.restoreBackup)
                }
            }
            
            Section {
                Button(.deleteAllData, role: .destructive) {
                    state.present(.confirmDeleteAllData)
                }
            }
        }
        .navigationTitle(.store)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .disabled(state.status == .processing)
        .sheet(item: sheet) { sheet in
            switch sheet {
            case .importItems:
                FileImporter(allowedContentTypes: [Configuration.vaultItems]) { url in
                    state.importItems(from: url)
                }
            case let .exportItems(url):
                FileExporter(urls: [url])
            case .restoreBackup:
                FileImporter(allowedContentTypes: [Configuration.vaultBackup]) { url in
                    state.restoreBackup(from: url)
                }
            case let .createBackup(url):
                FileExporter(urls: [url])
            }
        }
        .alert(.file, isPresented: isAlertPresented, presenting: alert) { alert in
            switch alert {
            case .confirmDeleteAllData:
                Button(.cancel, role: .cancel) {}
                
                Button(.deleteAllDataAction, role: .destructive) {
                    state.deleteAllData()
                }
            case .exportItemsDidFail:
                Text("foo")
            case .createBackupDidFail:
                Text("foo")
            case .deleteAllDataDidFail:
                Text("foo")
            }
        } message: { alert in
            switch alert {
            case .confirmDeleteAllData:
                Text(.deleteConfirmation)
            case .exportItemsDidFail:
                Text("foo")
            case .createBackupDidFail:
                Text("foo")
            case .deleteAllDataDidFail:
                Text("foo")
            }
        }
    }
    
}

extension StoreSettingsView {
    
    enum Sheet {
        
        case importItems
        case exportItems(URL)
        case restoreBackup
        case createBackup(URL)
        
        init?(_ action: StoreSettingsState.Action) {
            switch action {
            case .importItems:
                self = .importItems
            case let .exportItems(url):
                self = .exportItems(url)
            case .restoreBackup:
                self = .restoreBackup
            case let .createBackup(url):
                self = .createBackup(url)
            case .confirmDeleteAllData:
                return nil
            }
        }
        
    }
    
    enum Alert {
        
        case confirmDeleteAllData
        case exportItemsDidFail
        case createBackupDidFail
        case deleteAllDataDidFail
        
        init(_ failure: StoreSettingsState.Failure) {
            switch failure {
            case .exportItems:
                self = .exportItemsDidFail
            case .createBackup:
                self = .createBackupDidFail
            case .deleteAllData:
                self = .deleteAllDataDidFail
            }
        }
        
    }
    
}

extension StoreSettingsState.Action {
    
    init(_ sheet: StoreSettingsView.Sheet) {
        switch sheet {
        case .importItems:
            self = .importItems
        case let .exportItems(url):
            self = .exportItems(url)
        case .restoreBackup:
            self = .restoreBackup
        case let .createBackup(url):
            self = .createBackup(url)
        }
    }
    
}

extension StoreSettingsView.Sheet: Identifiable {
    
    var id: String {
        switch self {
        case .importItems:
            return "importItems"
        case .exportItems:
            return "exportItems"
        case .restoreBackup:
            return "restoreBackup"
        case .createBackup:
            return "createBackup"
        }
    }
    
}

extension StoreSettingsView.Alert: Identifiable {
    
    var id: Self { self }
    
}

#if DEBUG
struct StoreSettingsViewPreview: PreviewProvider {
    
    static let state = StoreSettingsState(service: .stub)
    
    static var previews: some View {
        StoreSettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        StoreSettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
