import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    @Published var length = 32 {
        didSet {
            Task {
                await generatePassword()
            }
        }
    }
    
    @Published var digitsEnabled = true {
        didSet {
            Task {
                await generatePassword()
            }
        }
    }
    
    @Published var symbolsEnabled = true {
        didSet {
            Task {
                await generatePassword()
            }
        }
    }
    
    @Published var password = ""
    
    func generatePassword() async {
        password = await service.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
    }
    
}
