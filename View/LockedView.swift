import Haptic
import Localization
import SwiftUI

private let successFeedback = SuccessFeedbackGenerator()
private let failureFeedback = FailureFeedbackGenerator()

#if os(iOS)
struct LockedView<Model>: View where Model: LockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: LockedError?
    @State private var isKeyboardVisible = false
    @Environment(\.scenePhase) private var scenePhase
    
    private let useBiometricsOnAppear: Bool
    
    init(_ model: Model, useBiometricsOnAppear: Bool) {
        self.model = model
        self.useBiometricsOnAppear = useBiometricsOnAppear
    }
    
    var body: some View {
        ZStack {
            Color.systemBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                UnlockField(LocalizedString.masterPassword, text: $model.password, action: model.loginWithMasterPassword)
                    .disabled(model.status == .unlocking)
                    .frame(maxWidth: 300)
                
                Group {
                    switch model.keychainAvailability {
                    case .enrolled(.touchID):
                        BiometricUnlockButton(.touchID) {
                            if !isKeyboardVisible {
                                model.loginWithBiometrics()
                            }
                        }
                    case .enrolled(.faceID):
                        BiometricUnlockButton(.faceID) {
                            if !isKeyboardVisible {
                                model.loginWithBiometrics()
                            }
                        }
                    case .notAvailable, .notEnrolled:
                        EmptyView()
                    }
                }
                .disabled(isKeyboardVisible)
            }
            .padding()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .active, useBiometricsOnAppear, model.status != .locked(cancelled: true) {
                model.loginWithBiometrics()
            }
        }
        .onReceive(model.error) { error in
            failureFeedback.play()
            self.error = error
        }
        .onReceive(model.done) { _ in
            successFeedback.play()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .onAppear {
            successFeedback.prepare()
            failureFeedback.prepare()
        }
    }
    
}

private extension LockedView {
    
    static func title(for error: LockedError) -> Text {
        switch error {
        case .wrongPassword:
            return Text(LocalizedString.invalidPassword)
        case .unlockFailed:
            return Text(LocalizedString.unlockFailed)
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct LockedViewPreview: PreviewProvider {
    
    static let model = LockedModelStub()
    
    static var previews: some View {
        Group {
            LockedView(model, useBiometricsOnAppear: false)
                .preferredColorScheme(.light)
            
            LockedView(model, useBiometricsOnAppear: false)
                .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
