import Localization
import SwiftUI

struct SetupView<Model>: View where Model: SetupModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var state = SetupState.masterPassword(.forward)
    @State private var passwordHint = PasswordHint.none
    @State private var setupFailedErrorPresented = false
    
    var body: some View {
        Group {
            switch state {
            case .masterPassword:
                VStack {
                    Spacer()
                    
                    MasterPasswordContent(password: $model.password, repeatedPassword: $model.repeatedPassword)
                    
                    switch passwordHint {
                    case .none:
                        EmptyView()
                    case .insecure:
                        ErrorBadge(LocalizedString.insecurePassword)
                    case .mismatch:
                        ErrorBadge(LocalizedString.passwordMismatch)
                    }
                    
                    Spacer()
                    
                    ContinueButton(LocalizedString.continue) {
                        switch model.passwordStatus {
                        case .mismatch:
                            passwordHint = .mismatch
                        case .insecure:
                            passwordHint = .insecure
                        case .complete:
                            switch model.biometricAvailability {
                            case .notAvailable, .notEnrolled:
                                state = .complete(.forward)
                            case .touchID:
                                state = .biometricKeychain(.forward, .touchID)
                            case .faceID:
                                state = .biometricKeychain(.forward, .faceID)
                            }
                        }
                    }
                }
                .onChange(of: model.password) { _ in
                    passwordHint = .none
                }
                .onChange(of: model.repeatedPassword) { _ in
                    passwordHint = .none
                }
            case .biometricKeychain(_ , let biometricType):
                VStack {
                    BackButton {
                        state = .masterPassword(.backward)
                    }
                    
                    Spacer()
                    
                    BiometricUnlockContent(biometricType: biometricType, enabled: $model.biometricUnlockEnabled)
                    
                    Spacer()
                    
                    ContinueButton(LocalizedString.continue) {
                        state = .complete(.forward)
                    }
                }
            case .complete:
                VStack {
                    BackButton {
                        switch model.biometricAvailability {
                        case .notAvailable, .notEnrolled:
                            state = .masterPassword(.backward)
                        case .touchID:
                            state = .biometricKeychain(.backward, .touchID)
                        case .faceID:
                            state = .biometricKeychain(.backward, .faceID)
                        }
                    }
                    
                    Spacer()
                    
                    CompleteContent()
                    
                    Spacer()
                    
                    ContinueButton(LocalizedString.createVault, action: model.completeSetup)
                }
                .onReceive(model.setupFailed) {
                    setupFailedErrorPresented = true
                }
                .alert(isPresented: $setupFailedErrorPresented) {
                    Alert(title: Text(LocalizedString.vaultCreationFailed))
                }
            }
        }
        .padding()
        .transition(state.direction.transition)
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}

private struct BackButton: View {
    
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                HStack {
                    Label {
                        Text(LocalizedString.back)
                    } icon: {
                        Image.back
                            .imageScale(.large)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
}

private struct ContinueButton: View {
    
    private let title: String
    private let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Text(title)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
}

private struct MasterPasswordContent: View {
    
    let password: Binding<String>
    let repeatedPassword: Binding<String>
    
    var body: some View {
        VStack(spacing: 40) {
            Image.password
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondaryLabel)
                .frame(width: 120, height: 120)
            
            Text(LocalizedString.chooseMasterPassword)
                .font(.title3)
            
            VStack {
                SecureField(LocalizedString.masterPassword, text: password)
                    .padding(.horizontal, 20)
                
                Divider()
                
                SecureField(LocalizedString.confirmPassword, text: repeatedPassword)
                    .padding(.horizontal, 20)
            }
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.textFieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
}

private struct BiometricUnlockContent: View {
    
    let biometricType: BiometricType
    let enabled: Binding<Bool>
    
    var body: some View {
        VStack(spacing: 40) {
            biometricType.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(enabled.wrappedValue ? .label : .secondaryLabel)
            
            switch biometricType {
            case .touchID:
                Toggle(LocalizedString.enableTouchIDUnlock, isOn: enabled)

            case .faceID:
                Toggle(LocalizedString.enableFaceIDUnlock, isOn: enabled)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
    }
    
}

private struct CompleteContent: View {
    
    var body: some View {
        VStack(spacing: 40) {
            Image.done
                .resizable()
                .scaledToFit()
                .foregroundColor(.appGreen)
                .frame(width: 120, height: 120)
            
            Text(LocalizedString.setupComplete)
                .font(.title)
        }
    }
    
}

private enum PasswordHint {
    
    case none
    case insecure
    case mismatch
    
}

private enum SetupState {
    
    case masterPassword(Direction)
    case biometricKeychain(Direction, BiometricType)
    case complete(Direction)
    
    var direction: Direction {
        switch self {
        case .masterPassword(let direction):
            return direction
        case .biometricKeychain(let direction, _):
            return direction
        case .complete(let direction):
            return direction
        }
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
