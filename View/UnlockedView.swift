import Model
import SwiftUI
import Collection

struct UnlockedView: View {
    
    @ObservedObject private var state: UnlockedState
    
    init(_ state: UnlockedState) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case .emptyStore:
                    EmptyStoreView()
                case .noSearchResults:
                    NoSearchResultsView()
                case let .items(collation):
                    ItemsView(collation)
                        .searchable(text: $state.searchText)
                case .locked:
                    EmptyView()
                case .loadingItemsFailed:
                    FailureView(.loadingVaultFailed) {
                        state.reload()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        state.showSettings()
                    } label: {
                        Image(systemName: SFSymbol.sliderHorizontal3.systemName)
                    }
                    
                    Button {
                        state.lock()
                    } label: {
                        Image(systemName: SFSymbol.lock.systemName)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        SelectItemTypeView { itemType in
                            state.showCreateItemSheet(itemType: itemType)
                        }
                    } label: {
                        Image(systemName: SFSymbol.plus.systemName)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(item: $state.sheet) { sheet in
            switch sheet {
            case let .settings(state):
                SettingsView(state)
            case let .createItem(state):
                CreateItemView(state)
            }
        }
    }
    #endif
        
    #if os(macOS)
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case .emptyStore:
                    EmptyStoreView()
                case .noSearchResults:
                    NoSearchResultsView()
                case let .items(collation):
                    ItemsView(collation)
                        .searchable(text: $state.searchText)
                case .locked:
                    EmptyView()
                case .loadingItemsFailed:
                    FailureView(.loadingVaultFailed) {
                        state.reload()
                    }
                }
            }
            .toolbar {
                Spacer()
                
                Menu {
                    SelectItemTypeView { itemType in
                        state.showCreateItemSheet(itemType: itemType)
                    }
                } label: {
                    Image(systemName: SFSymbol.plus.systemName)
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
            }
        }
        .sheet(item: $state.sheet) { sheet in
            switch sheet {
            case let .createItem(state):
                CreateItemView(state)
            }
        }
    }
    #endif
        
        
}
    
extension UnlockedView {
    
    struct EmptyStoreView: View {
        
        var body: some View {
            Text(.emptyVault)
                .font(.title)
        }
        
    }
    
    struct NoSearchResultsView: View {
        
        var body: some View {
            Text(.noResultsFound)
                .font(.title)
        }
        
    }
    
    struct ItemsView: View {
        
        private let collation: AlphabeticCollation<StoreItemDetailState>
        
        init(_ collation: AlphabeticCollation<StoreItemDetailState>) {
            self.collation = collation
        }
        
        var body: some View {
            List {
                ForEach(collation.sections) { section in
                    Section(section.key) {
                        ForEach(section.elements) { state in
                            NavigationLink {
                                StoreItemDetailView(state)
                            } label: {
                                StoreItemInfoView(state.name, description: state.description, type: state.primaryType)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        
    }
    
}

/*
#if DEBUG
struct UnlockedViewPreview: PreviewProvider {
    
    static let state = UnlockedState(collation: nil, service: .stub)
    
    static var previews: some View {
        UnlockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        UnlockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
*/
