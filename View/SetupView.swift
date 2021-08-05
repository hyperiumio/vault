import Resource
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
                    Image(systemName: SFSymbol.chevronBackward)
                        .font(.title)
                        .symbolVariant(.circle)
                        .foregroundColor(.accentColor)
                        .padding()
                        .onTapGesture {
                            Task {
                                await state.back()
                            }
                        }
                        .transition(.backButton)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .topLeading)
            
            Group {
                switch state.step {
                case .choosePassword:
                    SetupStepView(image: "Placeholder", title: Localized.chooseMasterPassword, description: Localized.chooseMasterPasswordDescription) {
                        SecureField(Localized.enterMasterPassword, text: $state.password)
                            .font(.title2)
                    }
                case .repeatPassword:
                    SetupStepView(image: "Placeholder", title: Localized.repeatMasterPassword, description: Localized.repeatMasterPasswordDescription) {
                        SecureField(Localized.enterMasterPassword, text: $state.repeatedPassword)
                            .font(.title2)
                    }
                case .enableBiometricUnlock(let biometryType):
                    SetupStepView(image: "Placeholder", title: biometryType.title, description: biometryType.description) {
                        Toggle("bar", isOn: $state.isBiometricUnlockEnabled)
                            .toggleStyle(.switch)
                            .tint(.accentColor)
                    }
                case .completeSetup:
                    SetupStepView(image: "Placeholder", title: Localized.setupComplete, description: Localized.setupComplete)
                        #if os(iOS)
                        .task {
                            Self.feedbackGenerator.notificationOccurred(.success)
                        }
                        #endif
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(state.direction.transition)
            .animation(.easeInOut, value: state.step)
            
            Button {
                Task {
                    await state.next()
                }
            } label: {
                Text(state.step.title)
                    .frame(maxWidth: .infinity)
                
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
}

extension SetupView {
    
    #if os(iOS)
    private static let feedbackGenerator = UINotificationFeedbackGenerator()
    #endif
    
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
        .scale.combined(with: .opacity).animation(.default)
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

private extension SetupState.Step {
    
    var title: String {
        switch self {
        case .choosePassword, .repeatPassword, .enableBiometricUnlock:
            return Localized.continue
        case .completeSetup:
            return Localized.setupComplete
        }
    }
    
}

private extension BiometryType {
    
    var description: String {
        switch self {
        case .touchID:
            return Localized.unlockWithTouchIDDescription
        case .faceID:
            return Localized.unlockWithFaceIDDescription
        }
    }
    
    var title: String {
        switch self {
        case .touchID:
            return Localized.enableTouchIDUnlock
        case .faceID:
            return Localized.enableFaceIDUnlock
        }
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
