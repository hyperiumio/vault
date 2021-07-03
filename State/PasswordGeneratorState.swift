import Crypto
import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    @Published var length = 32 {
        didSet {
            async {
                await generatePassword()
            }
        }
    }
    
    @Published var digitsEnabled = true {
        didSet {
            async {
                await generatePassword()
            }
        }
    }
    @Published var symbolsEnabled = true {
        didSet {
            async {
                await generatePassword()
            }
        }
    }
    
    @Published var password = ""
    
    func generatePassword() async {
        password = await Password(length: length, uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
    }
}
