public func Match(_ needle: String, in haystack: String) -> Bool {
    let needle = needle.lowercased()
    let haystack = haystack.lowercased()
    
    guard needle.count <= haystack.count else {
        return false
    }
    guard needle != haystack else {
        return true
    }
    
    var queryIndex = needle.startIndex
    var targetIndex = haystack.startIndex
    while queryIndex < needle.endIndex {
        guard targetIndex < haystack.endIndex else {
            return false
        }
        
        if needle[queryIndex] == haystack[targetIndex] {
            queryIndex = needle.index(after: queryIndex)
        }
        targetIndex = haystack.index(after: targetIndex)
    }
    
    return true
}
