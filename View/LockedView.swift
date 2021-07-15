import SwiftUI

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    
    init(_ state: LockedState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            MasterPasswordField(.masterPassword, text: $state.password) {
                Task {
                    await state.loginWithPassword()
                }
            }
            .disabled(state.status == .unlocking)
            .frame(maxWidth: 300)
            
            switch state.biometryType {
            case .some(let biometryType):
                Button {
                    Task {
                        await state.loginWithBiometry()
                    }
                } label: {
                    Image(systemName: biometryType.symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                }
                .frame(width: 40, height: 40)

            case .none:
                EmptyView()
            }
        }
        .task {
            await state.fetchKeychainAvailability()
        }
    }
    
}

private extension BiometryType {
    
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
