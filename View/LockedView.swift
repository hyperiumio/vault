import SwiftUI
import Crypto
#warning("TODO")
#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct LockedView<S>: View where S: LockedStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var error: LockedError?
    @State private var isKeyboardVisible = false
    @Environment(\.scenePhase) private var scenePhase
    
    private let useBiometricsOnAppear: Bool
    
    init(_ state: S) {
        self.state = state
        self.useBiometricsOnAppear = true
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                MasterPasswordField(.masterPassword, text: $state.password) {
                    async {
                        state.loginWithMasterPassword
                    }
                }
                .disabled(state.status == .unlocking)
                .frame(maxWidth: 300)
                
                Group {
                    switch state.keychainAvailability {
                    case .enrolled(let biometricType):
                        Button(role: nil) {
                            guard !isKeyboardVisible else {
                                return
                            }
                            await state.loginWithBiometrics()
                        } label: {
                            Image(systemName: biometricType.symbolName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                    case .notAvailable, .notEnrolled:
                        EmptyView()
                    }
                }
                .frame(width: 40, height: 40)
                .disabled(isKeyboardVisible)
            }
            .padding()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
    /*
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .active, useBiometricsOnAppear, state.status != .locked(cancelled: true) {
                state.loginWithBiometrics()
            }
        }
        .onReceive(state.error) { error in
            feedbackGenerator.notificationOccurred(.error)
            self.error = error
        }
        .onReceive(state.done) { _ in
            feedbackGenerator.notificationOccurred(.success)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onAppear {
            feedbackGenerator.prepare()
        }
        */
    }
    
}

private extension LockedView {
    
    static func title(for error: LockedError) -> Text {
        switch error {
        case .wrongPassword:
            return Text(.invalidPassword)
        case .unlockFailed:
            return Text(.unlockFailed)
        }
    }
    
}

private extension Keychain.BiometryType {
    
    var symbolName: SFSymbol {
        switch self {
        case .touchID:
            return .touchid
        case .faceID:
            return .faceid
        }
    }
    
}

#if DEBUG
struct LockedViewPreview: PreviewProvider {
    
    static let state = LockedStateStub()
    
    static var previews: some View {
        LockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
