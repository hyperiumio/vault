import Resource
import SwiftUI

struct SetupView: View {
    
    @ObservedObject private var state: SetupState
    
    init(_ state: SetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            BackButton(isVisisble: state.isBackButtonVisible) {
                Task {
                    await state.back()
                }
            }
            
            switch state.step {
            case .choosePassword:
                ChooseMasterPasswordView(password: $state.password)
            case .repeatPassword:
                RepeatPasswordView(repeatedPassword: $state.repeatedPassword)
            case .enableBiometricUnlock(let biometryType):
                EnableBiometricUnlockView(biometryType, isEnabled: $state.isBiometricUnlockEnabled)
            case .completeSetup:
                CompleteSetupView()
            }
            
            NextButton(state.step.title) {
                Task {
                    await state.next()
                }
            }
        }
        .padding()
    }
    
}


extension SetupView {
    
    struct BackButton: View {
        
        private let isVisisble: Bool
        private let action: () -> Void
        
        init(isVisisble: Bool, action: @escaping () -> Void) {
            self.isVisisble = isVisisble
            self.action = action
        }
        
        var body: some View {
            HStack {
                if isVisisble {
                    Image(systemName: SFSymbol.chevronBackward)
                        .font(.title)
                        .symbolVariant(.circle)
                        .foregroundColor(.accentColor)
                        .onTapGesture(perform: action)
                }
                
                Spacer()
            }
        }
        
    }
    
    struct NextButton: View {
        
        private let title: String
        private let action: () -> Void
        
        init(_ title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .controlProminence(.increased)
        }
        
    }
    
    struct ChooseMasterPasswordView: View {
        
        private let password: Binding<String>
        
        init(password: Binding<String>) {
            self.password = password
        }
        
        var body: some View {
            VStack {
                Spacer()
                
                Text(Localized.chooseMasterPassword)
                    .font(.title)
                
                Text(Localized.chooseMasterPasswordDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                SecureField(Localized.enterMasterPassword, text: password, prompt: nil)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
        
    }
    
    struct RepeatPasswordView: View {
        
        private let repeatedPassword: Binding<String>
        
        init(repeatedPassword: Binding<String>) {
            self.repeatedPassword = repeatedPassword
        }
        
        var body: some View {
            VStack {
                Spacer()
                
                Text(Localized.repeatMasterPassword)
                    .font(.title)
                
                Text(Localized.repeatMasterPasswordDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                SecureField(Localized.enterMasterPassword, text: repeatedPassword, prompt: nil)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
        
    }
    
    struct EnableBiometricUnlockView: View {
        
        private let biometryType: BiometryType
        private let isEnabled: Binding<Bool>
        
        internal init(_ biometryType: BiometryType, isEnabled: Binding<Bool>) {
            self.biometryType = biometryType
            self.isEnabled = isEnabled
        }
        
        var body: some View {
            VStack {
                Spacer()
                
                Image(systemName: biometryType.symbolName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: 100, height: 100, alignment: .center)
                
                Text(biometryType.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Toggle(biometryType.title, isOn: isEnabled)
                    .toggleStyle(.switch)
                    .tint(.accentColor)
                
                Spacer()
                    
            }
            .multilineTextAlignment(.center)
        }
        
    }
    
    struct CompleteSetupView: View {
        
        #if os(iOS)
        private let feedbackGenerator = UINotificationFeedbackGenerator()
        #endif
        
        var body: some View {
            VStack {
                Spacer()
                
                Text(Localized.setupComplete)
                    .font(.title)
                
                Image(systemName: SFSymbol.checkmark)
                    .resizable()
                    .scaledToFit()
                    .symbolVariant(.circle)
                    .foregroundStyle(.green)
                    .frame(maxWidth: 200, maxHeight: 200)
                
                Spacer()
            }
            .multilineTextAlignment(.center)
            .onAppear {
                #if os(iOS)
                feedbackGenerator.prepare()
                feedbackGenerator.notificationOccurred(.success)
                #endif
            }

        }
        
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
    
    var symbolName: String {
        switch self {
        case .touchID:
            return SFSymbol.touchid
        case .faceID:
            return SFSymbol.faceid
        }
    }
    
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
    
    static let service = SetupServiceStub()
    static let state = SetupState(dependency: service)
    
    @State static var password = ""
    @State static var repeatedPassword = ""
    
    static var previews: some View {
        SetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            
        SetupView.ChooseMasterPasswordView(password: $password)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.ChooseMasterPasswordView(password: $password)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        SetupView.RepeatPasswordView(repeatedPassword: $repeatedPassword)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.RepeatPasswordView(repeatedPassword: $repeatedPassword)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        SetupView.CompleteSetupView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.CompleteSetupView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
