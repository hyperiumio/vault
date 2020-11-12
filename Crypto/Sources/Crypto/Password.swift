import CommonCrypto

public func Password(length: Int, uppercase: Bool, lowercase: Bool, digit: Bool, symbol: Bool) throws -> String {
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
        throw CryptoError.passwordGenerationFailure
    }
    guard length >= symbolGroups.count else {
        throw CryptoError.passwordGenerationFailure
    }
    
    let sourceCharacters = symbolGroups.flatMap(\.characters)
    var password = [Character]()
    while password.count < length {
        let randomIndex = try RandomNumber(upperBound: sourceCharacters.endIndex)
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

private enum SymbolGroup {
    
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

private func RandomNumber(upperBound: Int) throws -> Int {
    var randomValue = UInt8(0)
    repeat {
        let status = CCRandomGenerateBytes(&randomValue, 1)
        guard status == kCCSuccess else {
            throw CryptoError.rngFailure
        }
    } while randomValue >= upperBound

    guard let result = Int(exactly: randomValue) else {
        throw CryptoError.rngFailure
    }
    
    return result
}
