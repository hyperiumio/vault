public protocol AlphabeticCollationElement: Comparable {
    
    var sectionKey: String { get }
    
}

public struct AlphabeticCollation<Element> where Element: AlphabeticCollationElement {
    
    public let sections: [Section]
    
    public init<S>(from elements: S) where S: Sequence, Element == S.Element  {
        let groupedElements = Dictionary(grouping: elements) { element in
            element.sectionKey.uppercased()
        }
        
        self.sections = groupedElements.sorted { lhs, rhs in
            lhs.key < rhs.key
        }.map { key, value in
            let key = key.uppercased()
            let elements = groupedElements[key]!.sorted()
            return Section(key: key, elements: elements)
        }
    }
    
    public init() {
        self.sections = []
    }
    
}

extension AlphabeticCollation {
    
    public struct Section {
        
        public let key: String
        public let elements: [Element]
        
    }
    
}

extension AlphabeticCollation.Section: Identifiable {
    
    public var id: String { key }
    
}
