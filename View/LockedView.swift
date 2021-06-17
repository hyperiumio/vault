import SwiftUI

#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct LockedView<Model>: View where Model: LockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: LockedError?
    @State private var isKeyboardVisible = false
    @Environment(\.scenePhase) private var scenePhase
    
    private let useBiometricsOnAppear: Bool
    
    init(_ model: Model) {
        self.model = model
        self.useBiometricsOnAppear = true
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                UnlockField(.masterPassword, text: $model.password) {
                    async {
                        model.loginWithMasterPassword
                    }
                }
                .disabled(model.status == .unlocking)
                .frame(maxWidth: 300)
                
                Group {
                    switch model.keychainAvailability {
                    case .enrolled(.touchID):
                        BiometricUnlockButton(.touchID) {
                            if !isKeyboardVisible {
                                async {
                                    await model.loginWithBiometrics()
                                }
                                
                            }
                        }
                    case .enrolled(.faceID):
                        BiometricUnlockButton(.faceID) {
                            if !isKeyboardVisible {
                                async {
                                    await model.loginWithBiometrics()
                                }
                            }
                        }
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
            if scenePhase == .active, useBiometricsOnAppear, model.status != .locked(cancelled: true) {
                model.loginWithBiometrics()
            }
        }
        .onReceive(model.error) { error in
            feedbackGenerator.notificationOccurred(.error)
            self.error = error
        }
        .onReceive(model.done) { _ in
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

#if DEBUG
struct LockedViewPreview: PreviewProvider {
    
    static let model = LockedModelStub()
    
    static var previews: some View {
        LockedView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
