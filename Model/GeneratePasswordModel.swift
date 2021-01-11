import Combine
import Crypto
import Foundation

class GeneratePasswordModel: ObservableObject {
    
    @Published var length = 32
    @Published var digitsEnabled = true
    @Published var symbolsEnabled = true
    @Published var password: String?
    
    private let operationQueue = DispatchQueue(label: "GeneratePasswordModelOperationQueue")
    
    func createPassword() {
        Publishers.CombineLatest3($length, $digitsEnabled, $symbolsEnabled)
            .receive(on: operationQueue)
            .map { length, digitsEnabled, symbolsEnabled in
                try? PasswordGenerator(length: length, uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$password)
    }
    
}

#if DEBUG
#endif
