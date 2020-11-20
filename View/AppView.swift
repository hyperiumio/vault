import Localization
import SwiftUI

struct AppView<Model>: View where Model: AppModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }

    #if os(macOS)
    var body: some View {
        Content(model.state)
            .frame(minWidth: 600, minHeight: 600)
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        Content(model.state)
    }
    #endif
    
}

private extension AppView {
    
    struct Content: View {
        
        private let state: Model.State
        
        init(_ state: Model.State) {
            self.state = state
        }
        
        var body: some View {
            switch state {
            case .bootstrap(let model):
                BootstrapView(model)
            case .setup(let model):
                SetupView(model)
            case .main(let model):
                MainView(model)
            }
        }
        
    }
    
}

#if DEBUG
struct AppViewPreview: PreviewProvider {
    
    static let model: AppModelStub = {
        let boostrapModel = BootstrapModelStub(status: .loadingFailed)
        let state = AppModelStub.State.bootstrap(boostrapModel)
        return AppModelStub(state: state)
    }()
    
    static var previews: some View {
        Group {
            AppView(model)
                .preferredColorScheme(.light)
            
            AppView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
