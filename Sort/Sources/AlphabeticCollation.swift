public struct AlphabeticCollation<Element> {
    
    public let sections: [Section]
    
    public init<S>(from elements: S, grouped identifier: (Element) -> String) where S: Sequence, Element == S.Element  {
        let groupedElements = Dictionary(grouping: elements) { element in
            identifier(element).uppercased().prefix(1)
        }
        
        self.sections = groupedElements.sorted { lhs, rhs in
            lhs.key < rhs.key
        }.map { key, value in
            let elements = groupedElements[key]?.sorted { lhs, rhs in
                identifier(lhs) < identifier(rhs)
            } ?? []
            let key = String(key)
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
