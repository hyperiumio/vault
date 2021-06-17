import SwiftUI

struct MainView<S>: View where S: MainStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
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
