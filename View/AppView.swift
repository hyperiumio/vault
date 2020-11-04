import Localization
import SwiftUI

#if os(macOS)
struct AppView<Model>: View where Model: AppModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }

    var body: some View {
        EmptyView()
    }
    
}
#endif

#if os(iOS)
struct AppView<Model>: View where Model: AppModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }

    var body: some View {
        switch model.state {
        case .bootstrap(let model):
            BootstrapView(model)
        case .setup(let model):
            SetupView(model)
        case .main(let model):
            MainView(model)
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct AppViewPreview: PreviewProvider {
    
    static let model: AppModelStub = {
        let boostrapModel = BootstrapModelStub(status: .loading)
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
