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
            state.currentAction == .selectBackupImport
        } set: { isPresented in
            state.currentAction = isPresented ? .selectBackupImport : nil
        }
        
        self.isSelectBackupExportPresented = Binding {
            state.currentAction == .selectBackupExport
        } set: { isPresented in
            state.currentAction = isPresented ? .selectBackupExport : nil
        }
        
        self.isConfirmDeleteAllDataPresented = Binding {
            state.currentAction == .confirmDeleteAllData
        } set: { isPresented in
            state.currentAction = isPresented ? .confirmDeleteAllData : nil
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
                    state.currentAction = .selectFilesExport
                }
                
                Button(.importItems) {
                    state.currentAction = .selectFilesImport
                }
            }
            
            Section {
                Button(.createBackup) {
                    state.currentAction = .selectBackupExport
                }
                
                Button(.restoreBackup) {
                    state.currentAction = .selectBackupImport
                }
            }
            
            Section {
                Button(.deleteAllData, role: .destructive) {
                    state.currentAction = .confirmDeleteAllData
                }
            }
        }
        .navigationTitle(.store)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .disabled(state.status == .processing)
        .alert(.deleteAllDataTitle, isPresented: isConfirmDeleteAllDataPresented) {
            Button(.cancel, role: .cancel) {}
            
            Button(.deleteAllDataAction, role: .destructive) {
                state.deleteAllData()
            }
         
        } message: {
            Text(.deleteAllDataMessage)
        }
        .sheet(isPresented: isSelectBackupImportPresented) {
            FileImporter(allowedContentTypes: [Configuration.vaultBackup]) { url in
                do {
                    print(url)
                    try FileManager.default.copyItem(at: url, to: Configuration.databaseDirectory.appendingPathComponent("Foo"))
                } catch let error {
                    print(error)
                }
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
