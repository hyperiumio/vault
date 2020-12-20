import Localization
import SwiftUI

#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct QuickAccessLockedView<Model>: View where Model: QuickAccessLockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: QuickAccessLockedError?
    @State private var isKeyboardVisible = false
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
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
                .frame(width: 40, height: 40)
                .disabled(isKeyboardVisible)
            }
            .padding()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
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
            model.loginWithBiometrics()
        }
    }
    #endif
    
    #if os(macOS)
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
                .frame(width: 40, height: 40)
                .disabled(isKeyboardVisible)
            }
            .padding()
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }
        .onReceive(model.error) { error in
            self.error = error
        }
    }
    #endif
    
}

private extension QuickAccessLockedView {
    
    static func title(for error: QuickAccessLockedError) -> Text {
        switch error {
        case .wrongPassword:
            return Text(LocalizedString.invalidPassword)
        case .unlockFailed:
            return Text(LocalizedString.unlockFailed)
        }
    }
    
}
