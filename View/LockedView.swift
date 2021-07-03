import SwiftUI

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    
    init(_ state: LockedState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            MasterPasswordField(.masterPassword, text: $state.password) {
                async {
                    await state.loginWithPassword()
                }
            }
            .disabled(state.status == .unlocking)
            .frame(maxWidth: 300)
            
            switch state.keychainAvailablility {
            case .enrolled(let biometryType):
                Button {
                    async {
                        await state.loginWithBiometry()
                    }
                } label: {
                    Image(systemName: biometryType.symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                }
                .frame(width: 40, height: 40)

            case .notAvailable, .notEnrolled, .none:
                EmptyView()
            }
        }
        .task {
            await state.fetchKeychainAvailability()
        }
    }
    
}

private extension LockedState.BiometryType {
    
    var symbolName: String {
        switch self {
        case .touchID:
            return .touchid
        case .faceID:
            return .faceid
        }
    }
    
}

extension LockedView {
    
    #if os(iOS)
    private static let feedbackGenerator = UINotificationFeedbackGenerator()
    #endif
    
}
