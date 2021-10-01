import Foundation

@MainActor
class RecoveryKeySettingsState: ObservableObject {
    
    @Published private(set) var status = Status.input
    @Published private(set) var recoveryKeyQRCodeImage: Data?
    @Published private(set) var recoveryKeyPDF: Data?
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    func presentFailure(_ failure: Failure) {
        status = .failure(failure)
    }
    
    func dismissPresentation() {
        status = .input
    }
    
    func generateRecoveryKeyQRCodeImage() {
        status = .processing
        Task {
            do {
                recoveryKeyQRCodeImage = try await service.recoveryKeyORCode
                status = .input
            } catch {
                status = .failure(.generateRecoveryKeyQRCodeImage)
            }
        }
    }
    
    func generateRecoveryKeyPDF() {
        status = .processing
        Task {
            do {
                recoveryKeyPDF = try await service.recoveryKeyPDF
                status = .input
            } catch {
                status = .failure(.generateRecoveryKeyPDF)
            }
        }
    }
    
    func discardRecoveryKeyPDF() {
        recoveryKeyPDF = nil
    }
    
}

extension RecoveryKeySettingsState {
    
    enum Status {
        
        case input
        case processing
        case failure(Failure)
        
    }
    
    enum Failure: Error {
        
        case generateRecoveryKeyQRCodeImage
        case generateRecoveryKeyPDF
        
    }
    
}

extension RecoveryKeySettingsState.Failure: Identifiable {
    
    var id: Self { self }
    
}
