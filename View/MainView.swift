import SwiftUI

struct MainView<MainState>: View where MainState: MainStateRepresentable {
    
    @ObservedObject private var state: MainState
    
    init(_ state: MainState) {
        self.state = state
    }
    
    var body: some View {
        switch state.state {
        case .locked(let state):
            LockedView(state)
        case .unlocked(let state):
            UnlockedView(state)
        }
    }
    
}

#if DEBUG
struct MainViewPreview: PreviewProvider {
    
    static var state: MainStateStub = {
        let lockedState = MainStateStub.LockedState()
        let state = MainStateStub.State.locked(state: lockedState)
        return MainStateStub(state: state)
    }()
    
    static var previews: some View {
        MainView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
