import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var state: SettingsState
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ state: SettingsState) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink {
                        SecuritySettingsView(state.securitySettingsState)
                    } label: {
                        Label(.security, systemImage: SFSymbol.lock.systemName)
                    }
                    
                    NavigationLink {
                        StoreSettingsView(state.storeSettingsState)
                    } label: {
                        Label(.store, systemImage: SFSymbol.cube.systemName)
                    }
                    
                    NavigationLink {
                        SyncSettingsView(state.syncSettingsState)
                    } label: {
                        Label(.sync, systemImage: SFSymbol.arrowTriangle2Circlepath.systemName)
                    }
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label(.about, systemImage: SFSymbol.bubbleLeft.systemName)
                    }
                }
            }
            .navigationTitle(.settings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        Text("foo")
    }
    #endif
    
    
}

#if DEBUG
struct SettingsViewPreview: PreviewProvider {
    
    static let state = SettingsState(service: .stub)
    
    static var previews: some View {
        SettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SettingsView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
