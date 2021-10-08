import SwiftUI

struct BiometricUnlockSetupView: View {
    
    @ObservedObject private var state: BiometricUnlockSetupState
    
    init(_ state: BiometricUnlockSetupState) {
        self.state = state
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.status == .input) {
            state.confirm()
        } image: {
            Image(state.biometry.image)
        } title: {
            Text(state.biometry.title)
        } description: {
            Text(state.biometry.description)
        } input: {
            Toggle(state.biometry.title, isOn: $state.isEnabled)
                .toggleStyle(.switch)
                .labelsHidden()
                .tint(.accentColor)
                .disabled(state.status == .setupComplete)
        } button: {
            Text(.continue)
        }
    }
    
}

private extension BiometricUnlockSetupState.Biometry {
    
    var image: String {
        switch self {
        case .touchID:
            return ImageAsset.unlockSetupTouchID.name
        case .faceID:
            return ImageAsset.unlockSetupFaceID.name
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .touchID:
            return .enableTouchIDUnlock
        case .faceID:
            return .enableFaceIDUnlock
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .touchID:
            return .enableFaceIDUnlockDescription
        case .faceID:
            return .enableTouchIDUnlockDescription
        }
    }
    
}

/*
#if DEBUG
struct UnlockSetupViewPreview: PreviewProvider {
    
    static let state = BiometricUnlockSetupState(unlockMethod: .touchID, isEnabled: false)
    
    static var previews: some View {
        UnlockSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        UnlockSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
*/
