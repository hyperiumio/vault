import SwiftUI

struct AppView<AppState>: View where AppState: AppStateRepresentable {
    
    @ObservedObject private var state: AppState
    
    init(_ state: AppState) {
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
        let boostrapState = BootstrapStateStub(status: .loadingFailed)
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
