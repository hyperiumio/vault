import Localization
import SwiftUI

struct SetupView<Model>: View where Model: SetupModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var viewState: ViewState
    @State private var direction: Direction? = Direction.forward
    
    init(_ model: Model) {
        self.model = model
        self._viewState = State(initialValue: ViewState(from: model.state))
    }
    
    var body: some View {
        Group {
            switch viewState {
            case .choosePassword(let choosePasswordModel):
                Screen {
                    ChoosePasswordView(choosePasswordModel)
                }
            case .repeatPassword(let repeatPasswordModel):
                Screen(action: model.previous) {
                    RepeatPasswordView(repeatPasswordModel)
                }
            case .enableBiometricUnlock(let enableBiometricUnlockModel):
                Screen(action: model.previous) {
                    EnableBiometricUnlockView(enableBiometricUnlockModel)
                }
            case .completeSetup(let completeSetupModel):
                Screen(action: model.previous) {
                    CompleteSetupView(completeSetupModel)
                }
            }
        }
        .onChange(of: model.state) { state in
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
    }
    
}

    
private extension SetupView where Model: SetupModelRepresentable {
    
    enum ViewState {
        
        case choosePassword(Model.ChoosePasswordModel)
        case repeatPassword(Model.RepeatPasswordModel)
        case enableBiometricUnlock(Model.EnableBiometricUnlockModel)
        case completeSetup(Model.CompleteSetupModel)
        
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
        
        init(from state: Model.State) {
            switch state {
            case .choosePassword(let model):
                self = .choosePassword(model)
            case .repeatPassword(_, let model):
                self = .repeatPassword(model)
            case .enableBiometricUnlock(_, _, let model):
                self = .enableBiometricUnlock(model)
            case .completeSetup(_, _, _, let model):
                self = .completeSetup(model)
            }
        }
        
    }
    
}

private struct Screen<Content>: View where Content: View {
    
    private let action: (() -> Void)?
    private let content: Content
    
    init(action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        VStack {
            if let action = action {
                Button {
                    withAnimation {
                        action()
                    }
                } label: {
                    HStack {
                        Image.back
                            .imageScale(.large)
                        
                        Spacer()
                    }
                }
            }
            
            content
        }
        .padding()
    }
    
}

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
    
    static let model: SetupModelStub = {
        let choosePasswordModel = ChoosePasswordModelStub()
        let state = SetupModelStub.State.choosePassword(choosePasswordModel)
        return SetupModelStub(state: state)
    }()
    
    static var previews: some View {
        Group {
            SetupView(model)
                .preferredColorScheme(.light)
            
            SetupView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
