import Combine
import Crypto
import Foundation

@MainActor
protocol GeneratePasswordModelRepresentable: ObservableObject, Identifiable {
    
    var length: Int { get set }
    var digitsEnabled: Bool { get set }
    var symbolsEnabled: Bool { get set }
    var password: String? { get set }
    
    func createPassword() async
    
}

@MainActor
class GeneratePasswordModel: GeneratePasswordModelRepresentable {
    
    @Published var length = 32
    @Published var digitsEnabled = true
    @Published var symbolsEnabled = true
    @Published var password: String?
    
    func createPassword() async {
        
    }
    
}

#if DEBUG
#endif
