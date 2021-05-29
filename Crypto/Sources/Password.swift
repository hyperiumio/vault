import CommonCrypto

public func Password(length: Int, uppercase: Bool, lowercase: Bool, digit: Bool, symbol: Bool, configuration: PasswordConfiguration = .production) throws -> String {
    var symbolGroups = Set<SymbolGroup>()
    if uppercase {
        symbolGroups.insert(.uppercase)
    }
    if lowercase {
        symbolGroups.insert(.lowercase)
    }
    if digit {
        symbolGroups.insert(.digit)
    }
    if symbol {
        symbolGroups.insert(.symbol)
    }
    
    guard !symbolGroups.isEmpty else {
        throw CryptoError.passwordGenerationFailed
    }
    guard length >= symbolGroups.count else {
        throw CryptoError.passwordGenerationFailed
    }
    
    let sourceCharacters = symbolGroups.flatMap(\.characters)
    var password = [Character]()
    while password.count < length {
        var randomValue = 0 as UInt8
        repeat {
            let status = configuration.rng(&randomValue, 1)
            guard status == kCCSuccess else {
                throw CryptoError.randomNumberGenerationFailed
            }
        } while randomValue >= sourceCharacters.endIndex

        let randomIndex = Int(randomValue)
        let randomCharacter = sourceCharacters[randomIndex]
        
        password.append(randomCharacter)
        if password.count != length {
            continue
        }
        
        for symbolGroup in symbolGroups {
            if Set(password).isDisjoint(with: symbolGroup.characters) {
                password = []
            }
        }
    }
    
    return String(password)
}

public struct PasswordConfiguration {
    
    let rng: (_ bytes: UnsafeMutableRawPointer, _ count: Int) -> CCRNGStatus
    
    public static let production = PasswordConfiguration(rng: CCRandomGenerateBytes)
    
}

enum SymbolGroup {
    
    case uppercase
    case lowercase
    case digit
    case symbol
    
    var characters: [Character] {
        switch self {
        case .uppercase:
            return Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        case .lowercase:
            return Array("abcdefghijklmnopqrstuvwxyz")
        case .digit:
            return Array("0123456789")
        case .symbol:
            return Array("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~")
        }
    }
    
}
