public struct AlphabeticCollation<Element> {
    
    public let sections: [Section]
    
    public init<S>(from elements: S, grouped identifier: (Element) -> String) async throws where S: AsyncSequence, Element == S.Element {
        var groupedElements = [String:[Element]]()
        for try await element in elements {
            let key = identifier(element).prefix(1).uppercased()
            
            if groupedElements[key] == nil {
                groupedElements[key] = []
            }
            
            groupedElements[key]?.append(element)
            groupedElements[key]?.sort { lhs, rhs in
                identifier(lhs) < identifier(rhs)
            }
        }
        
        self.sections = groupedElements.map(Section.init)
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
