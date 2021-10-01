import Shim
import SwiftUI

struct RecoveryKeySettingsView: View {
    
    @ObservedObject private var state: RecoveryKeySettingsState
    private let failure: Binding<RecoveryKeySettingsState.Failure?>
    
    init(_ state: RecoveryKeySettingsState) {
        self.state = state
        
        self.failure = Binding {
            if case let .failure(failure) = state.status {
                return failure
            } else {
                return nil
            }
        } set: { failure in
            if let failure = failure {
                state.presentFailure(failure)
            } else {
                state.dismissPresentation()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if let recoveryKey = state.recoveryKeyQRCodeImage, let image = UIImage(data: recoveryKey) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .transition(.appear)
            }
            
            Spacer()
            
            Button {
                state.generateRecoveryKeyPDF()
            } label: {
                Text(.printRecoveryKey)
                    .frame(maxWidth: 300)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.recoveryKey)
        .onAppear {
            state.generateRecoveryKeyQRCodeImage()
        }
        .alert(item: failure) { failure in
            switch failure {
            case .generateRecoveryKeyQRCodeImage:
                return Alert(title: Text(.generateRecoveryKeyQRCodeImageFailed))
            case .generateRecoveryKeyPDF:
                return Alert(title: Text(.generateRecoveryKeyPDFFailed))
            }
        }
        .onChange(of: state.recoveryKeyPDF) { recoveryKeyPDF in
            guard let recoveryKeyPDF = recoveryKeyPDF else {
                return
            }
            
            UIPrintInteractionController.shared.printingItem = recoveryKeyPDF
            UIPrintInteractionController.shared.present(animated: true) { _, _, _ in
                state.discardRecoveryKeyPDF()
            }
        }
    }
    
}

private extension AnyTransition {
    
    static var appear: Self {
        .opacity.animation(.easeIn)
    }
    
}

#if DEBUG
struct RecoveryKeySettingsViewPreview: PreviewProvider {
    
    static let state = RecoveryKeySettingsState(service: .stub)
    
    static var previews: some View {
        RecoveryKeySettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        RecoveryKeySettingsView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }

    
}
#endif
