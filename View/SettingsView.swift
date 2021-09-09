import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var state: SettingsState
    
    init(_ state: SettingsState) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        SecuritySettingsView(state.securitySettingsState)
                    } label: {
                        Label(.security, systemImage: .lockSymbol)
                    }
                    
                    NavigationLink {
                        StoreSettingsView(state.storeSettingsState)
                    } label: {
                        Label(.data, systemImage: "folder")
                    }
                    
                    NavigationLink {
                        StoreSettingsView(state.storeSettingsState)
                    } label: {
                        Label("Sync", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
                
                Section {
                    NavigationLink {
                        StoreSettingsView(state.storeSettingsState)
                    } label: {
                        Label("About", systemImage: "bubble.left")
                    }
                }
            }
            .navigationTitle(.settings)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
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
