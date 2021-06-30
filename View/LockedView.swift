import SwiftUI
#warning("todo")
#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    
    init(_ state: LockedState) {
        self.state = state
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                /*
                MasterPasswordField(.masterPassword, text: $state.password) {

                }
                .disabled(state.status == .unlocking)
                .frame(maxWidth: 300)
                 */
                
                /*
                Group {
                    switch state.keychainAvailability {
                    case .enrolled(let biometricType):
                        Button(role: nil) {
                            await state.loginWithBiometrics()
                        } label: {
                            /*
                            Image(systemName: biometricType.symbolName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                             */
                        }
                        .buttonStyle(.plain)
                    case .notAvailable, .notEnrolled:
                        EmptyView()
                    }
                }
                .frame(width: 40, height: 40)
                 */
            }
            .padding()
        }
    }
    
}

/*
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
 */
