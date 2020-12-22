import SwiftUI
import Storage

struct QuickAccessUnlockedView<Model>: View where Model: QuickAccessUnlockedModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        List {
            ForEach(model.itemCollation.sections) { section in
                Section {
                    ForEach(section.elements) { item in
                        Button {
                            model.selectItem(item)
                        } label: {
                            LoginCredentialView(title: item.title, username: item.username, url: item.url)
                        }
                    }
                } header: {
                    Text(section.key)
                }
            }
        }
        .searchBar($model.searchText)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            ForEach(model.itemCollation.sections) { section in
                Section {
                    ForEach(section.elements) { item in
                        Button {
                            model.selectItem(item)
                        } label: {
                            LoginCredentialView(title: item.title, username: item.username, url: item.url)
                        }
                    }
                } header: {
                    Text(section.key)
                }
            }
        }
    }
    #endif
    
}
