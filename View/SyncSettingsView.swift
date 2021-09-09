import SwiftUI

struct SyncSettingsView: View {
    
    @ObservedObject private var state: SyncSettingsState
    
    init(_ state: SyncSettingsState) {
        self.state = state
    }
    
    var body: some View {
        EmptyView()
    }
    
}
