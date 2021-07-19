import Foundation
import Model
import Sort

protocol QuickAccessUnlockedDependency {
    
    
    
}

@MainActor
class QuickAccessUnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.empty
    @Published var searchText = ""
    
    private let dependency: QuickAccessUnlockedDependency
    
    init(dependency: QuickAccessUnlockedDependency) {
        self.dependency = dependency
    }
    
}

extension QuickAccessUnlockedState {
    
    typealias Collation = AlphabeticCollation<LoginCredential>
    
    enum Status {
        
        case empty
        case value(Collation)
        
    }
    
}

extension LoginCredential: CollationElement {
    
    public var sectionKey: String {
        fatalError()
    }
    
    public static func < (lhs: LoginCredential, rhs: LoginCredential) -> Bool {
        fatalError()
    }
    
}
