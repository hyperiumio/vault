import SwiftUI

struct BiometrySetupView: View {
    
    @ObservedObject private var state: BiometrySetupState
    
    init(_ state: BiometrySetupState) {
        self.state = state
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.canCompleteBiometrySetup) {
            state.confirm()
        } image: {
            Image(state.biometryType.image)
        } title: {
            Text(state.biometryType.title)
        } description: {
            Text(state.biometryType.description)
        } input: {
            Toggle(state.biometryType.title, isOn: $state.isBiometricUnlockEnabled)
                .toggleStyle(.switch)
                .labelsHidden()
                .tint(.accentColor)
                .disabled(!state.isSetupEnabled)
        } button: {
            Text(.continue)
        }
    }
    
}

private extension BiometryType {
    
    var image: String {
        switch self {
        case .touchID:
            return .biometrySetupTouchID
        case .faceID:
            return .biometrySetupFaceID
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
            return .unlockWithTouchIDDescription
        case .faceID:
            return .unlockWithFaceIDDescription
        }
    }
    
}

#if DEBUG
struct BiometrySetupViewPreview: PreviewProvider {
    
    static let state = BiometrySetupState(biometryType: .touchID)
    
    static var previews: some View {
        BiometrySetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        BiometrySetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
