import Configuration
import SwiftUI
import Shim
import UniformTypeIdentifiers

struct StoreSettingsView: View {
    
    @ObservedObject private var state: StoreSettingsState
    private let isSelectBackupImportPresented: Binding<Bool>
    private let isSelectBackupExportPresented: Binding<Bool>
    private let isConfirmDeleteAllDataPresented: Binding<Bool>
    
    init(_ state: StoreSettingsState) {
        self.state = state
        
        self.isSelectBackupImportPresented = Binding {
            state.status == .action(.selectBackupImport)
        } set: { isPresented in
            if isPresented {
                state.selectBackupImport()
            } else {
                state.dismissActions()
            }
        }
        
        self.isSelectBackupExportPresented = Binding {
            false
            //state.status == .action(.selectBackupExport)
        } set: { isPresented in
            if isPresented {
                state.selectBackupImport()
            } else {
                state.dismissActions()
            }
        }
        
        self.isConfirmDeleteAllDataPresented = Binding {
            state.status == .action(.confirmDeleteAllData)
        } set: { isPresented in
            if isPresented {
                state.confirmDeleteAllData()
            } else {
                state.dismissActions()
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
                    //state.currentAction = .selectFilesExport
                }
                
                Button(.importItems) {
                    //state.currentAction = .selectFilesImport
                }
            }
            
            Section {
                Button(.createBackup) {
                    state.createBackup()
                }
                
                Button(.restoreBackup) {
                    state.selectBackupImport()
                }
            }
            
            Section {
                Button(.deleteAllData, role: .destructive) {
                    state.confirmDeleteAllData()
                }
            }
        }
        .navigationTitle(.store)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .disabled(state.status == .processing)
        .sheet(isPresented: isSelectBackupImportPresented) {
            FileImporter(allowedContentTypes: [Configuration.vaultBackup]) { url in
                state.restoreBackup(from: url)
            }
        }
        .sheet(isPresented: isSelectBackupExportPresented) {
            FileExporter(urls: [Configuration.databaseDirectory]) {
            }
        }
        .alert(.deleteAllDataTitle, isPresented: isConfirmDeleteAllDataPresented) {
            Button(.cancel, role: .cancel) {}
            
            Button(.deleteAllDataAction, role: .destructive) {
                state.deleteAllData()
            }
         
        } message: {
            Text(.deleteAllDataMessage)
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
