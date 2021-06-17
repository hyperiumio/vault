import SwiftUI

struct AppView<State>: View where State: AppStateRepresentable {
    
    @ObservedObject private var state: State
    
    init(_ state: State) {
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
        let boostrapModel = BootstrapModelStub(state: .loadingFailed)
        let mode = AppStateStub.Mode.bootstrap(boostrapModel)
        return AppStateStub(mode: mode)
    }()
    
    static var previews: some View {
        AppView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
