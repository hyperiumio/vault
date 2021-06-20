import SwiftUI

#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct CompleteSetupView<CompleteSetupState>: View where CompleteSetupState: CompleteSetupStateRepresentable {
    
    @ObservedObject private var state: CompleteSetupState
    @State private var displayError: CompleteSetupStateError?
    @State private var isCheckmarkVisible = false
    
    init(_ state: CompleteSetupState) {
        self.state = state
    }
    
    var enabledIntensions: Set<PageNavigationIntention> {
        state.isLoading ? [.backward] : [.backward, .forward]
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if isCheckmarkVisible {
                VStack(spacing: 20) {
                    Text(.setupComplete)
                        .font(.title)
                        .zIndex(0)
                    
                    Image(systemName: .checkmark)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .transition(AnyTransition.scale(scale: 2).combined(with: .opacity).animation(Animation.easeIn(duration: 0.5)))
            }
            
            Spacer()
            
            Button(.createVault, role: nil) {
                await state.createVault()
            }
            .disabled(!enabledIntensions.contains(.forward))
        }
        .alert(item: $displayError) { error in
            switch error {
            case .vaultCreationFailed:
                let title = Text(.invalidPassword)
                return Alert(title: title)
            }
        }
        .onAppear {
            #if os(iOS)
            feedbackGenerator.prepare()
            isCheckmarkVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                feedbackGenerator.notificationOccurred(.success)
            }
            #endif
        }

    }
    
}

#if DEBUG
struct CompleteSetupViewPreview: PreviewProvider {
    
    static let state = CompleteSetupStateStub()
    
    static var previews: some View {
        CompleteSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
