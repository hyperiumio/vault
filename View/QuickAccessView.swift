import SwiftUI

struct QuickAccessView<Model>: View where Model: QuickAccessModelRepresentable {
    
    @ObservedObject var model: Model
    private let cancel: () -> Void
    
    init(_ model: Model, cancel: @escaping () -> Void) {
        self.model = model
        self.cancel = cancel
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Group {
                switch model.state {
                case .locked(let model):
                    QuickAccessLockedView(model)
                case .unlocked(let model):
                    QuickAccessUnlockedView(model)
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
