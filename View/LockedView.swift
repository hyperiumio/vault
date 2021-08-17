import SwiftUI

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    
    init(_ state: LockedState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            MasterPasswordField(.masterPassword, text: $state.password) {
                state.unlockWithPassword()
            }
            .disabled(state.status == .unlocking)
            .frame(maxWidth: 300)
            
            switch state.biometryType {
            case let .some(biometryType):
                Button {
                    state.unlockWihtBiometry()
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
            state.fetchKeychainAvailability()
        }
    }
    
}

private extension BiometryType {
    
    var symbolName: String {
        switch self {
        case .touchID:
            return .touchidSymbol
        case .faceID:
            return .faceidSymbol
        }
    }
    
}

extension LockedView {
    
    #if os(iOS)
    private static let feedbackGenerator = UINotificationFeedbackGenerator()
    #endif
    
}

#if DEBUG
struct LockedViewPreview: PreviewProvider {
    
    static let state = LockedState(service: .stub)
    
    static var previews: some View {
        LockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        LockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
