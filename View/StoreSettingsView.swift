import SwiftUI

struct StoreSettingsView: View {
    
    @State private var isDeleteAllDataConfirmationVisible = false
    @ObservedObject private var state: StoreSettingsState
    
    init(_ state: StoreSettingsState) {
        self.state = state
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(.storeInfos) {
                    StoreInfoSettingsView(state.storeInfoSettingsState)
                }
            }
            
            Section {
                Button(.importItems) {
                    
                }
                
                Button(.exportItems) {
                    
                }
            }
            
            Section {
                Button(.createBackup) {
                    
                }
                
                Button(.restoreFromBackup) {
                    
                }
            }
            
            Section {
                Button(.deleteAllData, role: .destructive) {
                    isDeleteAllDataConfirmationVisible = true
                }
                .alert(.deleteAllDataTitle, isPresented: $isDeleteAllDataConfirmationVisible) {
                    Button(.cancel, role: .cancel) {}
                    
                    Button(.deleteAllDataAction, role: .destructive) {
                        state.deleteAllData()
                    }
                } message: {
                    Text(.deleteAllDataMessage)
                }
            }
        }
        .navigationTitle(.store)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .disabled(state.status == .processing)
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
