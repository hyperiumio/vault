import Haptic
import SwiftUI

struct FinishSetupView: View {
    
    @ObservedObject private var state: FinishSetupState
    private let presentsSetupFailure: Binding<Bool>
    
    init(_ state: FinishSetupState) {
        self.state = state
        
        self.presentsSetupFailure = Binding {
            state.status == .failedToComplete
        } set: { presentsSetupFailure in
            if presentsSetupFailure {
                state.presentSetupFailure()
            } else {
                state.dismissSetupFailure()
            }
        }
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.status == .readyToComplete) {
            state.completeSetup()
        } image: {
            Image(ImageAsset.completeSetup.name)
        } title: {
            Text(.setupCompleteTitle)
        } description: {
            Text(.setupCompleteDescription)
        } input: {
            ProgressView()
                .opacity(state.status == .finishingSetup ? 1 : 0)
        } button: {
            Text(.continue)
        }
        .onChange(of: state.status) { status in
            if status == .setupComplete {
                HapticFeedback.shared.play(.success)
            }
        }
        .alert(.vaultCreationFailed, isPresented: presentsSetupFailure) {
            Button(.cancel, role: .cancel) {
                state.dismissSetupFailure()
            }
            
            Button(.retry) {
                state.completeSetup()
            }
        }
    }
    
}

#if DEBUG
struct FinishSetupViewPreview: PreviewProvider {
    
    static let state = FinishSetupState(masterPassword: "foo", isBiometryEnabled: true, service: .stub)
    
    static var previews: some View {
        FinishSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FinishSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
