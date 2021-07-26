import Resource
import Model
import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject private var state: UnlockedState
    
    init(_ state: UnlockedState) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case .empty:
                    CreateFirstItemView { itemType in
                        state.showCreateItemSheet(itemType: itemType)
                    }
                case .noSearchResult:
                    NoSearchResults()
                case .items(let collation):
                    StoreItemList(collation)
                        .searchable(text: $state.searchText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        SelectItemTypeView { itemType in
                            state.showCreateItemSheet(itemType: itemType)
                        }
                    } label: {
                        Image(systemName: SFSymbol.plus)
                    }
                }
            }
        }
        .sheet(item: $state.sheet) { sheet in
            switch sheet {
            case .selectItemType:
                SelectItemTypeView { itemType in
                    state.showCreateItemSheet(itemType: itemType)
                }
            case .createItem(let state):
                CreateItemView(state)
            }
        }
    }
    
}

extension UnlockedView {
    
    struct CreateFirstItemView: View {
        
        private let action: (SecureItemType) -> Void
    
        init(action: @escaping (SecureItemType) -> Void) {
            self.action = action
        }
        
        var body: some View {
            VStack {
                Text(Localized.createFirstItem)
                    .font(.title)
                    .textCase(.none)
                
                Spacer()
                
                SelectItemTypeView(action: action)
                    .buttonStyle(.bordered)
                
                Spacer()
            }
        }
        
    }
    
    struct NoSearchResults: View {
        
        var body: some View {
            Text(Localized.noResultsFound)
                .font(.title)
        }
        
    }

    struct StoreItemList: View {
        
        private let collation: UnlockedState.Collation
        
        init(_ collation: UnlockedState.Collation) {
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
        }
        
    }
    
}

#if DEBUG
struct UnlockedViewPreview: PreviewProvider {
    
    static let service = UnlockedServiceStub()
    static let state = UnlockedState(dependency: service)
    
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
