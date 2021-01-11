import Combine
import Foundation
import Storage
import Sort
import Search

protocol QuickAccessUnlockedModelRepresentable: ObservableObject, Identifiable {
    
    typealias Collation = AlphabeticCollation<LoginCredential>
    
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var selected: AnyPublisher<LoginCredential, Never> { get }
    var failure: QuickAccessUnlockedFailure? { get }
    
    func selectItem(_ item: LoginCredential)
    
}

extension LoginCredential: AlphabeticCollationElement {
    
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

class QuickAccessUnlockedModel: QuickAccessUnlockedModelRepresentable {
    
    @Published var searchText = ""
    @Published private(set) var itemCollation: Collation
    @Published var failure: QuickAccessUnlockedFailure?
    
    var selected: AnyPublisher<LoginCredential, Never> {
        selectedSubject.eraseToAnyPublisher()
    }
    
    private var selectedSubject = PassthroughSubject<LoginCredential, Never>()
    private var itemCollationSubscription: AnyCancellable?
    private let operationQueue = DispatchQueue(label: "QuickAccessUnlockedModelOperationQueue")
    
    init(vaultItems: [StoreItemInfo: [LoginItem]]) {
        
        func loginCredetials(from vaultItems: [StoreItemInfo: [LoginItem]]) -> [LoginCredential] {
            vaultItems.flatMap { info, item in
                item.compactMap { item in
                    guard let username = item.username, let password = item.password else {
                        return nil
                    }
                    return LoginCredential(id: info.id, title: info.name, username: username, password: password, url: item.url)
                } as [LoginCredential]
            }
            
        }
        
        let credentials = loginCredetials(from: vaultItems)
        
        self.itemCollation = AlphabeticCollation<LoginCredential>(from: credentials)
        
        itemCollationSubscription = $searchText
            .receive(on: operationQueue)
            .map { searchText in
                loginCredetials(from: vaultItems).filter { credential in
                    FuzzyMatch(searchText, in: credential.title)
                        || FuzzyMatch(searchText, in: credential.username)
                        || FuzzyMatch(searchText, in: credential.url ?? "")
                }
            }
            .map { credentials in
                AlphabeticCollation<LoginCredential>(from: credentials)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.failure = .loadOperationFailed
                }
            } receiveValue: { [weak self] itemCollation in
                guard let self = self else { return }
                
                self.itemCollation = itemCollation
            }
    }
    
    func selectItem(_ item: LoginCredential) {
        selectedSubject.send(item)
    }
    
}
