import SwiftUI

struct AppView<S>: View where S: AppStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }

    var body: some View {
        switch state.mode {
        case .bootstrap(let state):
            BootstrapView(state)
        case .setup(let state):
            SetupView(state)
        case .main(let state):
            MainView(state)
        }
    }
    
}

#if DEBUG
struct AppViewPreview: PreviewProvider {
    
    static var state: AppStateStub = {
        let boostrapState = BootstrapStateStub(state: .loadingFailed)
        let mode = AppStateStub.Mode.bootstrap(boostrapState)
        return AppStateStub(mode: mode)
    }()
    
    static var previews: some View {
        AppView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
