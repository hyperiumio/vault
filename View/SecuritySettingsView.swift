import SwiftUI

struct SecuritySettingsView: View {
    
    @ObservedObject private var state: SecuritySettingsState
    
    init(_ state: SecuritySettingsState) {
        self.state = state
    }
    
    var body: some View {
        Form {
            if state.isExtendedUnlockAvailable {
                Section {
                    if state.unlockAvailability.touchID {
                        Toggle(.touchID, isOn: $state.isTouchIDUnlockEnabled)
                    }
                    
                    if state.unlockAvailability.faceID {
                        Toggle(.faceID, isOn: $state.isFaceIDUnlockEnabled)
                    }
                    
                    if state.unlockAvailability.watch {
                        Toggle(.appleWatch, isOn: $state.isWatchUnlockEnabled)
                    }
                    
                } header: {
                    Text(.unlock)
                } footer: {
                    Text(.extendedUnlockDescription)
                }
            }
            
            Section {
                Toggle(.hidePasswords, isOn: $state.hidePasswords)
            } footer: {
                Text(.hidePasswordsDescription)
            }
            
            Section {
                Toggle(.clearPasteboard, isOn: $state.clearPasteboard)
            } footer: {
                Text(.clearPasteboardDescription)
            }
            
            Section {
                NavigationLink(.changeMasterPassword) {
                    
                }
            } footer: {
                Text(.changeMasterPasswordDescription)
            }
            
            Section {
                NavigationLink(.recoveryKey) {
                    RecoveryKeySettingsView(state.recoveryKeySettingsState)
                }
            } footer: {
                Text(.recoveryKeyDescription)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.security)
    }
    
}

/*
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
*/
