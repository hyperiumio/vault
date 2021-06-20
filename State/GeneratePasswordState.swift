import Combine
import Crypto
import Foundation

#warning("Todo")
@MainActor
protocol GeneratePasswordStateRepresentable: ObservableObject, Identifiable {
    
    var length: Int { get set }
    var digitsEnabled: Bool { get set }
    var symbolsEnabled: Bool { get set }
    var password: String? { get set }
    
    func createPassword() async
    
}

@MainActor
class GeneratePasswordState: GeneratePasswordStateRepresentable {
    
    @Published var length = 32
    @Published var digitsEnabled = true
    @Published var symbolsEnabled = true
    @Published var password: String?
    
    func createPassword() async {
        
    }
    
}

#if DEBUG
#endif