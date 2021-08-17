import Collection
import Foundation

@MainActor
class CompleteSetupState: ObservableObject {

    @Published var setupError: SetupError?
    private let inputs = Queue<Input>()
    
    init(masterPassword: String, isBiometryEnabled: Bool, service: AppServiceProtocol) {
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case .completeSetup:
                    do {
                        try await service.completeSetup(isBiometryEnabled: isBiometryEnabled, masterPassword: masterPassword)
                    } catch {
                        setupError = .setupDidFail
                    }
                }
            }
        }
    }
    
    func completeSetup() {
        Task {
            await inputs.enqueue(.completeSetup)
        }
    }
    
}

extension CompleteSetupState {
    
    enum Input {
        
        case completeSetup
        
    }
    
    enum SetupError: Error {
        
        case setupDidFail
        
    }
    
}
