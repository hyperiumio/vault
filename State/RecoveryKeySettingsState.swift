import Foundation

@MainActor
class RecoveryKeySettingsState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    @Published private(set) var recoveryKeyPDFStatus = RecoveryKeyPDFStatus.none
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    func load() {
        status = .loading
        Task {
            do {
                let recoveryKey = try await service.recoveryKey
                status = .loaded(recoveryKey: recoveryKey)
            } catch {
                status = .loadingDidFail
            }
        }
    }
    
    func generateRecoveryKeyPDF() {
        recoveryKeyPDFStatus = .generating
        Task {
            do {
                let recoveryKeyPDF = try await service.recoveryKeyPDF
                recoveryKeyPDFStatus = .generated(recoveryKeyPDF: recoveryKeyPDF)
            } catch {
                recoveryKeyPDFStatus = .generationDidFail
            }
        }
    }
    
}

extension RecoveryKeySettingsState {
    
    enum Status {
        
        case initialized
        case loading
        case loaded(recoveryKey: Data)
        case loadingDidFail
        
    }
    
    enum RecoveryKeyPDFStatus {
        
        case none
        case generating
        case generated(recoveryKeyPDF: Data)
        case generationDidFail
        
    }
    
}
