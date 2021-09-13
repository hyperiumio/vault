import Combine
import Collection
import Foundation

@MainActor
class PasswordGeneratorState: ObservableObject {
    
    @Published var length = 32
    @Published var digitsEnabled = true
    @Published var symbolsEnabled = true
    @Published var password = ""
    private let inputBuffer = AsyncQueue<Input>()
    
    init(service: AppServiceProtocol) {
        let propertyStream = Publishers.CombineLatest3($length, $digitsEnabled, $symbolsEnabled).map(Input.generatePassword).values
        inputBuffer.enqueue(propertyStream)
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch input {
                case let .generatePassword(length, digitsEnabled, symbolsEnabled):
                    password = await service.password(length: length, digit: digitsEnabled, symbol: symbolsEnabled)
                }
            }
        }
    }
    
    func generatePassword() {
        let input = Input.generatePassword(length: length, digitsEnabled: digitsEnabled, symbolsEnabled: symbolsEnabled)
        Task {
            await inputBuffer.enqueue(input)
        }
    }
    
}


extension PasswordGeneratorState {
    
    enum Input {
        
        case generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
        
    }
    
}
