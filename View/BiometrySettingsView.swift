import SwiftUI

struct BiometrySettingsView: View {
    
    @ObservedObject private var state: BiometrySettingsState
    
    init(_ state: BiometrySettingsState) {
        self.state = state
    }
    
    var body: some View {
        switch state.biometryType {
        case .touchID:
            Section {
                Toggle(.useTouchID, isOn: $state.isBiometricUnlockEnabled)
            } footer: {
                Text(.touchIDDescription)
            }
        case .faceID:
            Section {
                Toggle(.useFaceID, isOn: $state.isBiometricUnlockEnabled)
            } footer: {
                Text(.faceIDDescription)
            }
        }
    }
    
}

#if DEBUG
struct BiometrySettingsViewPreview: PreviewProvider {
    
    static let state = BiometrySettingsState(biometryType: .faceID, isBiometricUnlockEnabled: false, service: .stub)
    
    static var previews: some View {
        List {
            BiometrySettingsView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BiometrySettingsView(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
