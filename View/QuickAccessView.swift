import Localization
import SwiftUI

struct QuickAccessView<Model>: View where Model: QuickAccessModelRepresentable {
    
    private let model: Model
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
                    LockedView(model, useBiometricsOnAppear: true)
                case .unlocked(let model):
                    CredentialProviderView(model)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
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
            
            Button(LocalizedString.cancel) {
              cancel()
            }
        }
    }
    #endif
    
}
