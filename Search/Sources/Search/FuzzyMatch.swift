public func FuzzyMatch(_ pattern: String, in string: String) -> Bool {
    guard pattern.count <= string.count else {
        return false
    }
    guard pattern != string else {
        return true
    }
    
    var queryIndex = pattern.startIndex
    var targetIndex = string.startIndex
    while queryIndex < pattern.endIndex {
        guard targetIndex < string.endIndex else {
            return false
        }
        
        if pattern[queryIndex] == string[targetIndex] {
            queryIndex = pattern.index(after: queryIndex)
        }
        targetIndex = string.index(after: targetIndex)
    }
    
    return true
}
