import Collection
import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    private let inputs = Queue<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case let .generatePassword(length, digitsEnabled, symbolsEnabled):
                    password = await service.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
                }
            }
        }
    }
    
    @Published var length = 32 {
        didSet {
            generatePassword()
        }
    }
    
    @Published var digitsEnabled = true {
        didSet {
            generatePassword()
        }
    }
    
    @Published var symbolsEnabled = true {
        didSet {
            generatePassword()
        }
    }
    
    @Published var password = ""
    
    func generatePassword() {
        let input = Input.generatePassword(length: length, digitsEnabled: digitsEnabled, symbolsEnabled: symbolsEnabled)
        Task {
            await inputs.enqueue(input)
        }
    }
    
}


extension PasswordGeneratorState {
    
    enum Input {
        
        case generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
        
    }
    
}
