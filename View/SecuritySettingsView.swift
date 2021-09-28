import Shim
import SwiftUI
import Visualization

struct SecuritySettingsView: View {
    
    @ObservedObject private var state: SecuritySettingsState
    @State var pdf: Data?
    
    init(_ state: SecuritySettingsState) {
        self.state = state
    }
    
    var body: some View {
        Form {
            Section {
                switch state.biometryType {
                case .touchID?:
                    Toggle(.useTouchID, isOn: $state.isBiometricUnlockEnabled)
                case .faceID?:
                    Toggle(.useFaceID, isOn: $state.isBiometricUnlockEnabled)
                case nil:
                    EmptyView()
                }
                
                Toggle("Use Apple Watch", isOn: $state.isWatchUnlockEnabled)
            } footer: {
                Text(.touchIDDescription)
            }
            
            Section {
                Toggle("Hide content", isOn: $state.hideContent)
            } footer: {
                Text("Hide content after unlock.")
            }
            
            Section {
                Toggle("Clear pasreboard", isOn: $state.clearPasteboard)
            } footer: {
                Text("Hide content after unlock.")
            }
            
            Section {
                Button("Change Master Password") {
                    
                }
            } footer: {
                Text(.changeMasterPasswordDescription)
            }
            
            Section {
                Button("Show Master Key") {
                    do {
                        pdf = try RestoreKitGenerate(title: "Vault Master Key", secretKey: Data(60 ... 126))
                    } catch let error {
                        print(error)
                    }
                }
            } footer: {
                Text("Show your master key")
            }
        }
        .sheet(item: $pdf) { pdf in
            Activity(item: pdf, title: "Vault Master Key", activityTypes: .print)
        }
    }
    
}

extension Data: Identifiable {
    
    public var id: Self { self }
    
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
