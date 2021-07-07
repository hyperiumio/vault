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
