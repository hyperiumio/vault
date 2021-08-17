import SwiftUI

struct BiometrySetupView: View {
    
    @ObservedObject private var state: BiometrySetupState
    
    init(_ state: BiometrySetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            Image(state.biometryType.image)
            
            Text(state.biometryType.title)
                .font(.title)
            
            Text(state.biometryType.description)
                .font(.body)
                .foregroundStyle(.secondary)
            
            Toggle(state.biometryType.title, isOn: $state.isBiometricUnlockEnabled)
                .toggleStyle(.switch)
                .tint(.accentColor)
            
            Spacer()
            
            Button {
                Task {
                    await state.done()
                }
            } label: {
                Text(.continue)
                    .frame(maxWidth: 400)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
        }
    }
    
}

private extension BiometryType {
    
    var image: String {
        switch self {
        case .touchID:
            return "BiometrySetupTouchID"
        case .faceID:
            return "BiometrySetupFaceID"
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
