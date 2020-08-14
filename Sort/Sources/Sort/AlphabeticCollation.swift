public protocol AlphabeticCollationElement: Comparable {
    
    var sectionKey: Character? { get }
    
}

public struct AlphabeticCollation<Element> where Element: AlphabeticCollationElement {
    
    public let sections: [Section]
    
    public init<S>(from elements: S) where S: Sequence, Element == S.Element  {
        let sortedElements = Dictionary(grouping: elements) { element in
            element.sectionKey ?? Character("?")
        }
        
        self.sections = sortedElements.keys.sorted().map { key in
            let elements = sortedElements[key]?.sorted() ?? []
            return Section(letter: key, elements: elements)
        }
    }
    
    public init() {
        self.sections = []
    }
    
}

extension AlphabeticCollation {
    
    public struct Section {
        
        public let letter: Character
        public let elements: [Element]
        
    }
    
}
