import SwiftUI

struct BiometricUnlock: View {
    
    let method: Method
    let unlock: () -> Void
    
    var body: some View {
        switch method {
        case .touchID:
            return Button("👇", action: unlock)
        case .faceID:
            return Button("👁️", action: unlock)
        }
    }
    
}


extension BiometricUnlock {
    
    enum Method {
        
        case touchID
        case faceID
        
    }
    
}

