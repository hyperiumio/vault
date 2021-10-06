import Combine
import Foundation
import Collection

@MainActor
class UnlockSetupState: ObservableObject {
    
    @Published private(set) var status = Status.input
    @Published var isEnabled: Bool
    let unlockMethod = UnlockMethod.touchID
    
    init(unlockMethod: UnlockMethod, isEnabled: Bool? = nil) {
        self.isEnabled = isEnabled ?? false
    }
    
    func confirm() {
        status = .setupComplete
    }
    
}

extension UnlockSetupState {
    
    enum UnlockMethod {
        
        case touchID
        case faceID
        case watch
        
    }
    
    enum Status {
        
        case input
        case setupComplete
        
    }
    
}
