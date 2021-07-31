import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
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
        password = await dependency.passwordService.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
    }
    
}
