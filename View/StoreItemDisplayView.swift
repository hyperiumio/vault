import Asset
import Model
import SwiftUI

struct StoreItemDisplayView: View {
    
    private let title: String
    private let primaryItem: SecureItem
    private let secondaryItems: [SecureItem]
    private let created: Date?
    private let modified: Date?
    private let edit: () -> Void
    
    init(_ title: String, primaryItem: SecureItem, secondaryItems: [SecureItem], created: Date?, modified: Date?, edit: @escaping () -> Void) {
        self.title = title
        self.primaryItem = primaryItem
        self.secondaryItems = secondaryItems
        self.created = created
        self.modified = modified
        self.edit = edit
    }
    
    var body: some View {
        List {
            Section {
                SecureItemField(primaryItem)
            } header: {
                Text(title)
                    .textCase(.none)
            } footer: {
                DateFooter(created: created, modified: modified)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(Localized.edit, action: edit)
            }
        }
    }
    
}
