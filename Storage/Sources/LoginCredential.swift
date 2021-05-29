import Foundation

public struct LoginCredential: Equatable, Identifiable {
    
    public let id: UUID
    public let title: String
    public let username: String
    public let password: String
    public let url: String?
    
    public init(id: UUID, title: String, username: String, password: String, url: String?) {
        self.id = id
        self.title = title
        self.username = username
        self.password = password
        self.url = url
    }
    
}
