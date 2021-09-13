import Collection
import Foundation

@MainActor
class FinishSetupState: ObservableObject {

    @Published private(set) var status = Status.readyToComplete
    private let masterPassword: String
    private let isBiometryEnabled: Bool
    private let service: AppServiceProtocol
    
    init(masterPassword: String, isBiometryEnabled: Bool, service: AppServiceProtocol) {
        self.masterPassword = masterPassword
        self.isBiometryEnabled = isBiometryEnabled
        self.service = service
    }
    
    func presentSetupFailure() {
        status = .failedToComplete
    }
    
    func dismissSetupFailure() {
        status = .readyToComplete
    }
    
    func completeSetup() {
        status = .finishingSetup
        
        Task {
            do {
                try await service.completeSetup(isBiometryEnabled: isBiometryEnabled, masterPassword: masterPassword)
                status = .setupComplete
            } catch {
                status = .failedToComplete
            }
        }
    }
    
}

extension FinishSetupState {
    
    enum Status {
        
        case readyToComplete
        case finishingSetup
        case setupComplete
        case failedToComplete
        
    }
    
}
