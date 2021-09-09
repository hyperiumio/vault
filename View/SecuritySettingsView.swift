import SwiftUI

struct SecuritySettingsView: View {
    
    @ObservedObject private var state: SecuritySettingsState
    
    init(_ state: SecuritySettingsState) {
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
struct SecuritySettingsViewPreview: PreviewProvider {
    
    static let state = SecuritySettingsState(service: .stub)
    
    static var previews: some View {
        List {
            SecuritySettingsView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            SecuritySettingsView(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
