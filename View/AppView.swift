import Localization
import SwiftUI

struct AppView<Model>: View where Model: AppModelRepresentable {
    
    @ObservedObject var model: Model
    
    #if os(macOS)
    var body: some View {
        Content(state: model.state)
            .frame(minWidth: 500, minHeight: 500)
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        Content(state: model.state)
    }
    #endif
    
    init(_ model: Model) {
        self.model = model
    }
    
}

private extension AppView {
    
    struct Content: View {
        
        let state: Model.State
        
        var body: some View {
            switch state {
            case .bootstrap(let model):
                BootstrapView(model)
            case .setup(let model):
                SetupView(model)
            case .locked(let model):
                LockedView(model)
            case .unlocked(let model):
                UnlockedView(model: model)
            }
        }
        
    }
    
}
