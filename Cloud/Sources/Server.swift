import CloudKit

public struct Server {
    
    private let container: CKContainer
    
    public init(containerIdentifier: String) {
        self.container = CKContainer(identifier: containerIdentifier)
    }
    
}
