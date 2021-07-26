import Resource
import SwiftUI
import Model

struct QuickAccessUnlockedView: View {
    
    @ObservedObject private var state: QuickAccessUnlockedState
    
    init(_ state: QuickAccessUnlockedState) {
        self.state = state
    }
    
    var body: some View {
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

extension QuickAccessUnlockedView {
    
    struct Empty: View {
        
        private let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        var body: some View {
            VStack(spacing: 30) {
                Text(Localized.emptyVault)
                    .font(.title)
            }
        }
        
    }

    struct Value: View {
        
        private let collation: QuickAccessUnlockedState.Collation
        
        init(_ collation: QuickAccessUnlockedState.Collation) {
            self.collation = collation
        }
        
        var body: some View {
            if collation.sections.isEmpty {
                Text(Localized.noResultsFound)
                    .font(.title)
            } else {
                List {
                    ForEach(collation.sections) { section in
                        Section {
                            ForEach(section.elements) { item in
                                Button {
                                    
                                } label: {
                                    LoginCredentialField(item)
                                }
                            }
                        } header: {
                            Text(section.key)
                        }
                    }
                }
            }
        }
        
    }
    
}

#if DEBUG
struct QuickAccessUnlockedViewPreview: PreviewProvider {
    
    static let service = QuickAccessUnlockedServiceStub()
    static let state = QuickAccessUnlockedState(dependency: service)
    
    static var previews: some View {
        QuickAccessUnlockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        QuickAccessUnlockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
