import Foundation

public enum ImportError: Error {
    
    case importFailed
    
}

public func Import1PIF(from data: Data) throws -> [VaultItem] {
    let dataAsString = String(bytes: data, encoding: .utf8)

    let pattern = #"\*{3}.*\*{3}"#

    let dataArray = dataAsString!.split(usingRegex: pattern).filter { element in
        !element.isEmpty
    }
    
    let onePIFObjects = try dataArray.map({ jsonString in
        return try decodeJSON(jsonString.data(using: .utf8)!)
    })
    
    return mapFrom1PIFsToVaults(onePIFObjects)
}
