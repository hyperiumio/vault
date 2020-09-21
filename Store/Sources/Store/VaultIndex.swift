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
    
    func header(for id: UUID) throws -> Header {
        guard let value = values[id] else {
            throw NSError()
        }
        
        return value.header
    }
    
    func info(for id: UUID) throws -> VaultItem.Info {
        guard let value = values[id] else {
            throw NSError()
        }
        
        return value.info
    }
    
    var infos: [VaultItem.Info] {
        values.values.map(\.info)
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
        
        let header: Header
        let info: VaultItem.Info
        
    }
    
}
