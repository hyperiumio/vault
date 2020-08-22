import Foundation

#if os(macOS)
class LockedSettingsModel: ObservableObject {
    
    @Published var state = State.locked
    
    private let context: PreferencesModelContext
    
    init(context: PreferencesModelContext) {
        self.context = context
    }
}

extension LockedSettingsModel {
    
    enum State {
        
        case locked
        case unlocked(SettingsModel)
        
    }
    
}
#endif
