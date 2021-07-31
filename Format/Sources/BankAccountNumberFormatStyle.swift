import Foundation

public struct BankAccountNumberFormatStyle {
    
    public init() {}
    
}

extension BankAccountNumberFormatStyle: ParseableFormatStyle {
    
    public var parseStrategy: Self {
        self
    }
    
    public func format(_ value: String) -> String {
        let input = value.components(separatedBy: .whitespaces).joined()

        let chunkSize = 4
        return stride(from: 0, to: input.count, by: chunkSize).map { offset in
            let startIndex = input.index(input.startIndex, offsetBy: offset)
            let endIndex = input.index(startIndex, offsetBy: chunkSize, limitedBy: input.endIndex) ?? input.endIndex
            let chunk = input[startIndex ..< endIndex]
            return String(chunk)
        }.joined(separator: " ")
    }
    
}

extension BankAccountNumberFormatStyle: ParseStrategy {
    
    public func parse(_ value: String) -> String {
        value.components(separatedBy: .whitespaces).joined()
    }
    
}

extension FormatStyle where Self == BankAccountNumberFormatStyle {

    public static var bankAccountNumber: Self {
        Self()
    }
    
}
