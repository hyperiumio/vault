import Configuration
import SwiftUI
import Shim
import UniformTypeIdentifiers

struct StoreSettingsView: View {
    
    @ObservedObject private var state: StoreSettingsState
    private let action: Binding<StoreSettingsState.Action?>
    private let confimation: Binding<StoreSettingsState.Confimation?>
    private let failure: Binding<StoreSettingsState.Failure?>
    
    init(_ state: StoreSettingsState) {
        self.state = state
        
        self.action = Binding {
            if case let .action(action) = state.status {
                return action
            } else {
                return nil
            }
        } set: { action in
            if let action = action {
                state.presentAction(action)
            } else {
                state.dismissPresentation()
            }
        }
        
        self.confimation = Binding {
            if case let .confirmation(confimation) = state.status {
                return confimation
            } else {
                return nil
            }
        } set: { confimation in
            if let confimation = confimation {
                state.presentConfirmation(confimation)
            } else {
                state.dismissPresentation()
            }
        }
        
        self.failure = Binding {
            if case let .failure(failure) = state.status {
                return failure
            } else {
                return nil
            }
        } set: { failure in
            if let failure = failure {
                state.presentFailure(failure)
            } else {
                state.dismissPresentation()
            }
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
                    state.presentAction(.importItems)
                }
            }
            
            Section {
                Button(.createBackup) {
                    state.createBackup()
                }
                
                Button(.restoreBackup) {
                    state.presentAction(.restoreBackup)
                }
            }
            
            Section {
                Button(.deleteAllData, role: .destructive) {
                    state.presentConfirmation(.deleteAllData)
                }
            }
        }
        .navigationTitle(.store)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .disabled(state.status == .processing)
        .sheet(item: action) { action in
            switch action {
            case let .exportItems(url):
                FileExporter(urls: [url])
            case .importItems:
                FileImporter(allowedContentTypes: [Configuration.vaultItems]) { url in
                    state.importItems(from: url)
                }
            case let .createBackup(url):
                FileExporter(urls: [url])
            case .restoreBackup:
                FileImporter(allowedContentTypes: [Configuration.vaultBackup]) { url in
                    state.restoreBackup(from: url)
                }
            }
        }
        .alert(item: failure) { failure in
            switch failure {
            case .exportItems:
                return Alert(title: Text(.exportItemsDidFail))
            case .importItems:
                return Alert(title: Text(.importItemsDidFail))
            case .createBackup:
                return Alert(title: Text(.createBackupDidFail))
            case .restoreBackup:
                return Alert(title: Text(.restoreBackupDidFail))
            case .deleteAllData:
                return Alert(title: Text(.deleteAllDataDidFail))
            }
            
        }
        .actionSheet(item: confimation) { confimation in
            switch confimation {
            case .deleteAllData:
                let buttons = [
                    ActionSheet.Button.cancel(),
                    ActionSheet.Button.destructive(Text(.deleteAllDataAction)) {
                        state.deleteAllData()
                    }
                ]
                return ActionSheet(title: Text(.deleteAllDataTitle), message: Text(.deleteAllDataMessage), buttons: buttons)
            }
        }
    }
    
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
