import SwiftUI

struct SetupView: View {
    
    @ObservedObject private var state: SetupState
    
    init(_ state: SetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if state.isBackButtonVisible {
                    Image(systemName: .chevronBackwardSymbol)
                        .font(.title)
                        .symbolVariant(.circle)
                        .foregroundColor(.accentColor)
                        .padding()
                        .transition(.backButton)
                        .onTapGesture {
                            state.back()
                        }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .topLeading)
            
            Group {
                switch state.step {
                case let .choosePassword(state):
                    MasterPasswordSetupView(state)
                case let .repeatPassword(_, state):
                    RepeatMasterPasswordSetupView(state)
                case let .biometricUnlock(_, _, state):
                    BiometrySetupView(state)
                case let .completeSetup(_, _, _, state):
                    CompleteSetupView(state)
                }
            }
            .padding([.leading, .trailing, .bottom])
            .transition(state.direction.transition)
            .animation(.easeInOut, value: state.step.index)
        }
    }
    
}

private extension SetupState.Direction {
    
    var transition: AnyTransition {
        switch self {
        case .forward:
            return .forward
        case .backward:
            return .backward
        }
    }
    
}

private extension AnyTransition {
    
    static var backButton: Self {
        .scale(scale: 0.5).combined(with: .opacity).animation(.default)
    }
    
    static var forward: Self {
        let insertion = AnyTransition.move(edge: .trailing)
        let removal = AnyTransition.move(edge: .leading)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var backward: Self {
        let insertion = AnyTransition.move(edge: .leading)
        let removal = AnyTransition.move(edge: .trailing)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

#if DEBUG
struct SetupViewPreview: PreviewProvider {
    
    static let state = SetupState(service: .stub)
    
    static var previews: some View {
        SetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
