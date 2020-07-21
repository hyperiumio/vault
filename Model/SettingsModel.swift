import Foundation

#if os(macOS)
class SettingsModel: ObservableObject {
    
    @Published var state = State.locked
    
    private let context: PreferencesModelContext
    
    init(context: PreferencesModelContext) {
        self.context = context
    }
}

extension SettingsModel {
    
    enum State {
        
        case locked
        case unlocked(SettingsUnlockedModel)
        
    }
    
}
#endif
