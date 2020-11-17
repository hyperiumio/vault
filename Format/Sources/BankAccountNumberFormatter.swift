import Foundation

public class BankAccountNumberFormatter: Formatter {
    
    public override func string(for obj: Any?) -> String? {
        guard let input = (obj as? String)?.components(separatedBy: .whitespaces).joined() else {
            return nil
        }
 
        let chunkSize = 4
        return stride(from: 0, to: input.count, by: chunkSize).map { offset in
            let startIndex = input.index(input.startIndex, offsetBy: offset)
            let endIndex = input.index(startIndex, offsetBy: chunkSize, limitedBy: input.endIndex) ?? input.endIndex
            let chunk = input[startIndex ..< endIndex]
            return String(chunk)
        }.joined(separator: " ")
    }
    
    public override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let output = string.components(separatedBy: .whitespaces).joined()
        obj?.pointee = NSString(string: output)
        return true
    }
    
}
