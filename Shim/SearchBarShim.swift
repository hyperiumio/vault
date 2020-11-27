#if os(iOS)
import SwiftUI

extension List {
    
    func searchBar(_ searchText: Binding<String>) -> some View {
        let resolver = SearchBarShim(searchText)
            .frame(width: 0, height: 0)
        
        return overlay(resolver)
    }
}

private struct SearchBarShim: UIViewControllerRepresentable {
    
    private let searchText: Binding<String>
    
    init(_ searchText: Binding<String>) {
        self.searchText = searchText
    }
    
    func makeUIViewController(context: Context) -> SearchBarViewController {
        SearchBarViewController(searchText)
    }
    
    func updateUIViewController(_ uiViewController: SearchBarViewController, context: Context) {}
}

private class SearchBarViewController: UIViewController {
    
    private let searchText: Binding<String>
    
    init(_ searchText: Binding<String>) {
        self.searchText = searchText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        guard let parent = parent else { return }
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        parent.navigationItem.searchController = searchController
    }
}

extension SearchBarViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchText.wrappedValue = searchController.searchBar.text ?? ""
    }
    
}
#endif
