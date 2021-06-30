/*
import SwiftUI
#warning("todo")
struct QuickAccessView: View {
    
    @ObservedObject var state: QuickAccessState
    private let cancel: () -> Void
    
    init(_ state: QuickAccessState, cancel: @escaping () -> Void) {
        self.state = state
        self.cancel = cancel
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case .locked(let state, _):
                    QuickAccessLockedView(state)
                case .unlocked(let state):
                    QuickAccessUnlockedView(state)
                case .loading:
                    EmptyView()
                case .loadingFailed:
                    Text("Error")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        cancel()
                    }
                }
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        VStack {
            Text("CredentialProviderView")
            
            Button(.cancel) {
              cancel()
            }
        }
    }
    #endif
    
}
*/
