import SwiftUI
#warning("todo")
struct SetupView<S>: View where S: SetupStateRepresentable {
    
    @ObservedObject private var state: S
    //@State private var viewState: ViewState
    @State private var direction: Direction? = Direction.forward
    
    init(_ state: S) {
        self.state = state
    //    self._viewState = State(initialValue: ViewState(from: state.state))
    }
    
    var body: some View {
        Text("foo")
        /*
        Group {
            switch viewState {
            case .choosePassword(let choosePasswordState):
                ChoosePasswordView(choosePasswordState)
            case .repeatPassword(let repeatPasswordState):
                RepeatPasswordView(repeatPasswordState)
            case .enableBiometricUnlock(let enableBiometricUnlockState):
                EnableBiometricUnlockView(enableBiometricUnlockState)
            case .completeSetup(let completeSetupState):
                CompleteSetupView(completeSetupState)
            }
        }
        .onChange(of: state.state) { state in
            let newViewState = ViewState(from: state)
            
            if viewState.presentationIndex < newViewState.presentationIndex {
                direction = .forward
            }
            if viewState.presentationIndex == newViewState.presentationIndex {
                direction = nil
            }
            if viewState.presentationIndex > newViewState.presentationIndex {
                direction = .backward
            }
            
            withAnimation {
                self.viewState = newViewState
            }
        }
        .transition(direction?.transition ?? AnyTransition.identity)
         */
    }
    
}

    /*
private extension SetupView where S: SetupStateRepresentable {
    
    enum ViewState {
        
        case choosePassword(S.ChoosePasswordState)
        case repeatPassword(S.RepeatPasswordState)
        case enableBiometricUnlock(S.EnableBiometricUnlockState)
        case completeSetup(S.CompleteSetupState)
        
        var presentationIndex: Int {
            switch self {
            case .choosePassword:
                return 0
            case .repeatPassword:
                return 1
            case .enableBiometricUnlock:
                return 2
            case .completeSetup:
                return 3
            }
        }
        
        init(from state: S.State) {
            switch state {
            case .choosePassword(let state):
                self = .choosePassword(state)
            case .repeatPassword(_, let state):
                self = .repeatPassword(state)
            case .enableBiometricUnlock(_, _, let state):
                self = .enableBiometricUnlock(state)
            case .completeSetup(_, _, _, let state):
                self = .completeSetup(state)
            }
        }
        
    }
    
}*/

private enum Direction {
    
    case forward
    case backward
    
    var transition: AnyTransition {
        switch self {
        case .forward:
            let insertion = AnyTransition.move(edge: .trailing)
            let removal = AnyTransition.move(edge: .leading).combined(with: .opacity)
            return .asymmetric(insertion: insertion, removal: removal)
        case .backward:
            let insertion = AnyTransition.move(edge: .leading)
            let removal = AnyTransition.move(edge: .trailing).combined(with: .opacity)
            return .asymmetric(insertion: insertion, removal: removal)
        }
    }
    
}

#if DEBUG
struct SetupViewPreview: PreviewProvider {
    
    static let state: SetupStateStub = {
        let choosePasswordState = ChoosePasswordStateStub()
        return SetupStateStub(step: .choosePassword(choosePasswordState))
    }()
    
    static var previews: some View {
        SetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
