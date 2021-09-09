import SwiftUI

struct StoreSettingsView: View {
    
    @ObservedObject private var state: StoreSettingsState
    
    init(_ state: StoreSettingsState) {
        self.state = state
    }
    
    var body: some View {
        Text("foo")
    }
    
}
