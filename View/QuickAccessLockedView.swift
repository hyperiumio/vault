import SwiftUI

#warning("Todo")
#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct QuickAccessLockedView<S>: View where S: QuickAccessLockedStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var error: QuickAccessLockedError?
    @State private var isKeyboardVisible = false
    
    init(_ state: S) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        ZStack {
     //       Color.systemBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                /*
                UnlockField(.masterPassword, text: $state.password, action: state.loginWithMasterPassword)
                    .disabled(state.status == .unlocking)
                    .frame(maxWidth: 300)*/
                
                Group {
                    switch state.keychainAvailability {
                    case .enrolled(.touchID):
                        BiometricUnlockButton(.touchID) {
                            if !isKeyboardVisible {
                        //        state.loginWithBiometrics()
                            }
                        }
                    case .enrolled(.faceID):
                        BiometricUnlockButton(.faceID) {
                            if !isKeyboardVisible {
                        //        state.loginWithBiometrics()
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
        /*
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
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
            state.loginWithBiometrics()
        }*/
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        ZStack {
           // Color.systemBackground.edgesIgnoringSafeArea(.all)
            
            /*
            VStack(spacing: 20) {
                UnlockField(.masterPassword, text: $state.password, action: state.loginWithMasterPassword)
                    .disabled(state.status == .unlocking)
                    .frame(maxWidth: 300)
                
                Group {
                    switch state.keychainAvailability {
                    case .enrolled(.touchID):
                        BiometricUnlockButton(.touchID) {
                            if !isKeyboardVisible {
                                state.loginWithBiometrics()
                            }
                        }
                    case .enrolled(.faceID):
                        BiometricUnlockButton(.faceID) {
                            if !isKeyboardVisible {
                                state.loginWithBiometrics()
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
        .onReceive(state.error) { error in
            self.error = error
        }
             */
        }
    }
    #endif
    
}

private extension QuickAccessLockedView {
    
    static func title(for error: QuickAccessLockedError) -> Text {
        switch error {
        case .wrongPassword:
            return Text(.invalidPassword)
        case .unlockFailed:
            return Text(.unlockFailed)
        }
    }
    
}
