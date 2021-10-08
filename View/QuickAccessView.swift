import SwiftUI

struct QuickAccessView: View {
    
    @ObservedObject private var state: QuickAccessState
    private let cancel: () -> Void
    
    init(_ state: QuickAccessState, cancel: @escaping () -> Void) {
        self.state = state
        self.cancel = cancel
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case let .locked(state):
                    LockedView(state)
                case let .unlocked(state):
                    LoginCredentialSelectionView(state)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        cancel()
                    }
                }
            }
        }
    }
    
}

#if DEBUG
struct QuickAccessViewPreview: PreviewProvider {
    
    static let state = QuickAccessState(service: .stub)
    
    static var previews: some View {
        QuickAccessView(state) {
            print("cancel")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        QuickAccessView(state) {
            print("cancel")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
