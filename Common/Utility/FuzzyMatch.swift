func FuzzyMatch(query: String, target: String) -> Bool {
    guard query.count <= target.count else {
        return false
    }
    guard query != target else {
        return true
    }
    
    var queryIndex = query.startIndex
    var targetIndex = target.startIndex
    while queryIndex < query.endIndex {
        guard targetIndex < target.endIndex else {
            return false
        }
        
        if query[queryIndex] == target[targetIndex] {
            queryIndex = query.index(after: queryIndex)
        }
        targetIndex = target.index(after: targetIndex)
    }
    
    return true
}
