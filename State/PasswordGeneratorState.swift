import Foundation

@MainActor
protocol PasswordGeneratorDependency {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    
}

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    private let dependency: PasswordGeneratorDependency
    
    init(dependency: PasswordGeneratorDependency) {
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
        password = await dependency.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
    }
    
}
