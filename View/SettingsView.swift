import SwiftUI

#if os(macOS)
struct SettingsView: View {
    
    @ObservedObject var model: SettingsModel
    
    var body: some View {
        switch model.state {
        case .locked:
            SettingsLockedView()
        case .unlocked(let model):
            SettingsUnlockedView(model: model, cancel: {})
        }
    }
    
}
#endif
