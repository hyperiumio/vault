import Resource
import SwiftUI

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    
    init(_ state: LockedState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            MasterPasswordField(Localized.masterPassword, text: $state.password) {
                Task {
                    await state.unlock(with: .password)
                }
            }
            .disabled(state.status == .unlocking)
            .frame(maxWidth: 300)
            
            switch state.biometryType {
            case .some(let biometryType):
                Button {
                    Task {
                        await state.unlock(with: .biometry)
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
            return SFSymbol.touchid
        case .faceID:
            return SFSymbol.faceid
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
