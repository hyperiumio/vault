import Asset
import Model
import SwiftUI

struct UnlockedView: View {
    
    @ObservedObject private var state: UnlockedState
    
    init(_ state: UnlockedState) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            switch state.status {
            case .empty:
                Empty {
                    
                }
            case .value(let collation):
                Value(collation)
                    .searchable(text: $state.searchText)
            }
        }
    }
    
}

extension UnlockedView {
    
    struct Empty: View {
        
        private let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            VStack(spacing: 30) {
                Text(Localized.emptyVault)
                    .font(.title)
                
                Button(Localized.createFirstItem, action: action)
            }
        }
        
    }

    struct Value: View {
        
        private let collation: UnlockedState.Collation
        
        init(_ collation: UnlockedState.Collation) {
            self.collation = collation
        }
        
        var body: some View {
            if collation.sections.isEmpty {
                Text(Localized.noResultsFound)
                    .font(.title)
            } else {
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
    
}
