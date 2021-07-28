import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    private let passwordService: PasswordServiceProtocol
    
    init(dependency: Dependency) {
        self.passwordService = dependency.passwordService
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
        password = await passwordService.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
    }
    
}
