import Foundation

struct VaultIndex<Header> {
    
    private let values: [UUID: Element]
    
    init() {
        values = [:]
    }
    
    init(_ elements: [Element]) {
        var values = [UUID: Element]()
        
        for element in elements {
            values[element.info.id] = element
        }
        
        self.values = values
    }
    
    init(_ values: [UUID: Element]) {
        self.values = values
    }
    
    var infos: [VaultItem.Info] {
        values.values.map(\.info)
    }
    
    func element(for id: UUID) throws -> Element {
        guard let value = values[id] else {
            throw NSError()
        }
        
        return value
    }
    
    func add(_ element: Element) -> Self {
        var values = self.values
        values[element.info.id] = element
        
        return Self(values)
    }
    
    func delete(_ itemID: UUID) -> Self {
        var values = self.values
        values[itemID] = nil
        
        return Self(values)
    }
    
}

extension VaultIndex {
    
    struct Element {
        
        let url: URL
        let header: Header
        let info: VaultItem.Info
        
    }
    
}
