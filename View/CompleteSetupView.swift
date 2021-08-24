import Haptic
import SwiftUI

struct CompleteSetupView: View {
    
    @ObservedObject private var state: CompleteSetupState
    private let presentsSetupFailure: Binding<Bool>
    
    init(_ state: CompleteSetupState) {
        self.state = state
        
        self.presentsSetupFailure = Binding {
            state.presentsSetupFailure
        } set: { presentsSetupFailure in
            state.presentsSetupFailure = presentsSetupFailure
        }
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.canCompleteSetup) {
            state.completeSetup()
        } image: {
            Image(.completeSetupImage)
        } title: {
            Text(.setupCompleteTitle)
        } description: {
            Text(.setupCompleteDescription)
        } input: {
            ProgressView()
                .opacity(state.isLoading ? 1 : 0)
        } button: {
            Text(.continue)
        }
        .onChange(of: state.isComplete) { newValue in
            HapticFeedback.shared.play(.success)
        }
        .alert(.vaultCreationFailed, isPresented: presentsSetupFailure) {
            Button(.cancel, role: .cancel) {
                state.presentsSetupFailure = false
            }
            
            Button(.retry) {
                state.completeSetup()
            }
        }
    }
    
}

#if DEBUG
struct CompleteSetupViewPreview: PreviewProvider {
    
    static let state = CompleteSetupState(masterPassword: "foo", isBiometryEnabled: true, service: .stub)
    
    static var previews: some View {
        CompleteSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        CompleteSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
