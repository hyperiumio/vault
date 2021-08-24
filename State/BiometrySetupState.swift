import Combine
import Foundation
import Event

@MainActor
class BiometrySetupState: ObservableObject {
    
    @Published private(set) var status = Status.biometrySetup
    @Published var isBiometricUnlockEnabled = false
    let biometryType: BiometryType
    private let outputMulticast = EventMulticast<Output>()
    
    init(biometryType: BiometryType) {
        self.biometryType = biometryType
    }
    
    var output: AsyncStream<Output> {
        outputMulticast.events
    }
    
    var isSetupEnabled: Bool {
        status == .biometrySetup
    }
    
    var canCompleteBiometrySetup: Bool {
        status != .setupComplete
    }
    
    func confirm() {
        status = .setupComplete
        outputMulticast.send(.didSetupBiometry)
        outputMulticast.finish()
    }
    
}

extension BiometrySetupState {
    
    enum Status {
        
        case biometrySetup
        case setupComplete
        
    }
    
    enum Output {
        
        case didSetupBiometry
        
    }
    
}
