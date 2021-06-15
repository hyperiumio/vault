import SwiftUI

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

#if DEBUG
struct AppViewPreview: PreviewProvider {
    
    static var model: AppModelStub = {
        let boostrapModel = BootstrapModelStub(state: .loadingFailed)
        let state = AppModelStub.State.bootstrap(boostrapModel)
        return AppModelStub(state: state)
    }()
    
    static var previews: some View {
        AppView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
