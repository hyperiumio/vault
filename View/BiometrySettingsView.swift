import Asset
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
                Toggle(Localized.useTouchID, isOn: $state.isBiometricUnlockEnabled)
            } footer: {
                Text(Localized.touchIDDescription)
            }
        case .faceID:
            Section {
                Toggle(Localized.useFaceID, isOn: $state.isBiometricUnlockEnabled)
            } footer: {
                Text(Localized.faceIDDescription)
            }
        }
    }
    
}
