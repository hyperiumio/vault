import Localization
import SwiftUI

#if os(macOS)
struct AppView: View {
    
    @ObservedObject var model: AppModel
    
    var body: some View {
        Group {
            switch model.state {
            case .bootstrap(let model):
                BootstrapView(model: model)
            case .setup(let model):
                SetupView(model: model)
            case .locked(let model):
                LockedView(model: model)
            case .unlocked(let model):
                UnlockedView(model: model)
            }
        }
        .frame(minWidth: 500, minHeight: 500)
    }
    
}
#endif

#if os(iOS)
struct AppView: View {
    
    @ObservedObject var model: AppModel
    
    var body: some View {
        Group {
            switch model.state {
            case .bootstrap(let model):
                BootstrapView(model: model)
            case .setup(let model):
                ScrollView(showsIndicators: false) {
                    SetupView(model: model)
                }
            case .locked(let model):
                ScrollView(showsIndicators: false) {
                    LockedView(model: model)
                }
            case .unlocked(let unlockedModel):
                UnlockedView(model: unlockedModel)
                    .environmentObject(model)
            }
        }
    }
    
}
#endif
