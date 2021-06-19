import SwiftUI
import Model

#warning("Todo")
struct QuickAccessUnlockedView<S>: View where S: QuickAccessUnlockedStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        List {
            ForEach(state.itemCollation.sections) { section in
                Section {
                    ForEach(section.elements) { item in
                        Button {
                //            state.selectItem(item)
                        } label: {
                            LoginCredentialField(title: item.title, username: item.username, url: item.url)
                        }
                    }
                } header: {
                    Text(section.key)
                }
            }
        }
        .searchable(text: $state.searchText)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            /*
            ForEach(state.itemCollation.sections) { section in
                Section {
                    ForEach(section.elements) { item in
                        Button {
                            state.selectItem(item)
                        } label: {
                            LoginCredentialField(title: item.title, username: item.username, url: item.url)
                        }
                    }
                } header: {
                    Text(section.key)
                }
            }
             */
        }
    }
    #endif
    
}

private extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
}
