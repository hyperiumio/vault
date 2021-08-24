import Event
import Foundation

@MainActor
class CompleteSetupState: ObservableObject {

    @Published private var status = Status.readyToComplete
    private let masterPassword: String
    private let isBiometryEnabled: Bool
    private let service: AppServiceProtocol
    
    init(masterPassword: String, isBiometryEnabled: Bool, service: AppServiceProtocol) {
        self.masterPassword = masterPassword
        self.isBiometryEnabled = isBiometryEnabled
        self.service = service
    }
    
    var isLoading: Bool {
        status == .finishingSetup
    }
    
    var canCompleteSetup: Bool {
        status == .readyToComplete
    }
    
    var isComplete: Bool {
        status == .setupComplete
    }
    
    var presentsSetupFailure: Bool {
        get {
            status == .failedToComplete
        }
        set(presentsSetupFailure) {
            status = presentsSetupFailure ? .failedToComplete : .readyToComplete
        }
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

extension CompleteSetupState {
    
    enum Status {
        
        case readyToComplete
        case finishingSetup
        case setupComplete
        case failedToComplete
        
    }
    
}
