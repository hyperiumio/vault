import Combine
import Foundation
import Model
import Sort
import Search

@MainActor
protocol QuickAccessUnlockedStateRepresentable: ObservableObject, Identifiable {
    
    typealias Collation = AlphabeticCollation<LoginCredential>
    
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var failure: QuickAccessUnlockedFailure? { get }
    
    func selectItem(_ item: LoginCredential) async
    
}

@MainActor
class QuickAccessUnlockedState: QuickAccessUnlockedStateRepresentable {
    
    @Published var searchText = ""
    @Published private(set) var itemCollation: Collation
    @Published var failure: QuickAccessUnlockedFailure?

    
    init(vaultItems: [StoreItemInfo: [LoginItem]]) {
        fatalError()
    }
    
    func selectItem(_ item: LoginCredential) async {
        
    }
    
}

extension LoginCredential: CollationElement {
    
    public var sectionKey: String {
        let firstCharacter = title.prefix(1)
        return String(firstCharacter)
    }
    
    public static func < (lhs: LoginCredential, rhs: LoginCredential) -> Bool {
        lhs.title < rhs.title
    }
    
}

enum QuickAccessUnlockedFailure {
    
    case loadOperationFailed
    
}
